//
//  Imversed+NFT.swift
//  Imversed
//
//  Created by Ilya S. on 06.12.2021.
//

import Foundation
import GRPC
import SwiftProtobuf

public struct NFT {
    static var connection: ClientConnection?
    
    private static let callOptions = CallOptions(logger: Logger.grpcLogger(label: "NFT"))
}

// MARK: - Query

public extension NFT {
    
    static func queryToken(
        id: String,
        denom: Imversed.Token.Denom,
        completion: @escaping (Result<Imversed.Token, Error>) -> Void
    ) {
        guard let connection = self.connection else {
            completion(.failure(Imversed.Error.notConfigured))
            return
        }
        
        let client = Imversed_Nft_QueryClient(channel: connection, defaultCallOptions: self.callOptions)
        let request = Imversed_Nft_QueryNFTRequest.with({
            $0.denomID = denom
            $0.tokenID = id
        })
        
        client.nft(request).response.whenComplete({ result in
            switch result {
            case .success(let response):
                do {
                    let token = try Imversed.Token(imversed: response.nft, denom: denom)
                    completion(.success(token))
                } catch {
                    Logger.log(.error(error))
                    completion(.failure(NSError(error) ?? error))
                }
                
            case .failure(let error):
                Logger.log(.error(error))
                completion(.failure(NSError(error) ?? error))
            }
        })
    }
    
    static func queryLastTokens(
        skip: Int = 0,
        limit: Int = 30,
        denom: Imversed.Token.Denom,
        completion: @escaping (Result<([Imversed.Token], Bool, Int), Error>) -> Void
    ) {
        guard let connection = self.connection else {
            completion(.failure(Imversed.Error.notConfigured))
            return
        }
        
        let client = Imversed_Nft_QueryClient(channel: connection, defaultCallOptions: self.callOptions)
        let request = Imversed_Nft_QueryCollectionRequest.with({
            $0.denomID = denom
            $0.pagination = Cosmos_Base_Query_V1beta1_PageRequest.with({
                $0.offset = UInt64(skip)
                $0.limit = UInt64(limit)
                $0.reverse = true
            })
        })
        
        client.collection(request).response.whenComplete({ result in
            switch result {
            case .success(let response):
                let nfts = response.collection.nfts
                let tokens = nfts.compactMap({ try? Imversed.Token(imversed: $0, denom: denom) })
                let nftsCount = nfts.count
                let finished = nftsCount < limit
                completion(.success((tokens, finished, nftsCount)))

            case .failure(let error):
                completion(.failure(NSError(error) ?? error))
            }
        })
    }
    
    static func queryTokens(
        address: Wallet.CosmAddress,
        denom: Imversed.Token.Denom,
        skip: Int = 0,
        limit: Int = 30,
        completion: @escaping (Result<[Imversed.Token], Error>) -> Void
    ) {
        self.queryTokenIds(
            address: address,
            denom: denom,
            skip: UInt64(skip),
            limit: UInt64(limit),
            completion: { result in
                switch result {
                case .success(let tokenIds):
                    self.queryTokens(by: tokenIds, denom: denom, completion: completion)
                    
                case .failure(let error):
                    completion(.failure(NSError(error) ?? error))
                }
            }
        )
    }
    
    private static func queryTokenIds(
        address: Wallet.CosmAddress,
        denom: Imversed.Token.Denom,
        skip: UInt64 = 0,
        limit: UInt64 = 30,
        completion: @escaping (Result<[Imversed.Token.Identifier], Error>) -> Void
    ) {
        guard let connection = self.connection else {
            completion(.failure(Imversed.Error.notConfigured))
            return
        }
        
        let client = Imversed_Nft_QueryClient(channel: connection, defaultCallOptions: self.callOptions)
        let request = Imversed_Nft_QueryOwnerRequest.with({
            $0.owner = address
            $0.denomID = denom
            $0.pagination = Cosmos_Base_Query_V1beta1_PageRequest.with({
                $0.offset = skip
                $0.limit = limit
            })
        })
        client.owner(request).response.whenComplete({ result in
            switch result {
            case .success(let response):
                let tokenIds = response.owner.idCollections.reduce([], { partialResult, collection in
                    return partialResult + collection.tokenIds
                })
                
                Logger.log(.info("Token ids queried: \(tokenIds)"))
                completion(.success(tokenIds))
                
            case .failure(let error):
                Logger.log(.error(error))
                completion(.failure(NSError(error) ?? error))
            }
        })
    }
    
    private static func queryTokens(
        by ids: [Imversed.Token.Identifier],
        denom: Imversed.Token.Denom,
        completion: @escaping (Result<[Imversed.Token], Error>) -> Void
    ) {
        var queryError: Error?
        var tokens: [Imversed.Token] = []
        
        let group = DispatchGroup()
        ids.forEach({ id in
            group.enter()
            
            self.queryToken(id: id, denom: denom, completion: { result in
                defer { group.leave() }
                
                switch result {
                case .success(let token):
                    tokens.append(token)
                    
                case .failure(let error):
                    queryError = error
                }
            })
        })
        
        group.notify(queue: .global(qos: .utility), execute: {
            if let error = queryError {
                Logger.log(.error(error))
                completion(.failure(NSError(error) ?? error))
            } else {
                completion(.success(tokens))
            }
        })
    }
    
}

// MARK: - Tx

extension NFT {
    
    enum Route {
        case mint, transfer, burn
        
        var path: String {
            switch self {
            case .mint:     return "/imversed.nft.MsgMintNFT"
            case .transfer: return "/imversed.nft.MsgTransferNFT"
            case .burn:     return "/imversed.nft.MsgBurnNFT"
            }
        }
        
        var legacy: String {
            switch self {
            case .mint:     return "imversed/nft/MsgMintNFT"
            case .transfer: return "imversed/nft/MsgTransferNFT"
            case .burn:     return "imversed/nft/MsgBurnNFT"
            }
        }
    }
    
}

// MARK: Minting

public extension NFT {
    
    static func transaction(
        mint request: MintRequest,
        with mnemonic: Wallet.Mnemonic,
        fees: Imversed.Fee,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let connection = self.connection else {
            completion(.failure(Imversed.Error.notConfigured))
            return
        }

        Tx.performTransaction(
            channel: connection,
            route: Route.mint.path,
            message: request,
            fees: fees,
            mnemonic: mnemonic,
            completion: { result in
                switch result {
                case .success(let response):
                    if response.txResponse.code != 0 {
                        let txResponse = response.txResponse
                        let error = Imversed.Error.broadcastFailed(code: txResponse.code, log: txResponse.rawLog)

                        Logger.log(.error(error))
                        completion(.failure(error))
                    } else {
                        Logger.log(.info("NFT minted with txHash: \(response.txResponse.txhash)"))
                        
                        TxListener.append(
                            waiting: .init(
                                txHash: response.txResponse.txhash,
                                completion: completion
                            )
                        )
                    }

                case .failure(let error):
                    Logger.log(.error(error))
                    completion(.failure(NSError(error) ?? error))
                }
            }
        )
    }
    
    static func simulate(
        mint request: MintRequest,
        with mnemonic: Wallet.Mnemonic,
        feeDenom: Imversed.Coin.Denom,
        completion: @escaping (Result<Imversed.Fee, Error>) -> Void
    ) {
        guard let connection = self.connection else {
            completion(.failure(Imversed.Error.notConfigured))
            return
        }
        
        Tx.simulateTransaction(
            channel: connection,
            route: Route.mint.path,
            message: request,
            mnemonic: mnemonic,
            completion: { result in
                switch result {
                case .success(let response):
                    let coins = Utils.Estimate.getFees(
                        for: .mintNft,
                        denom: feeDenom,
                        gasUsed: response.gasInfo.gasUsed
                    )
                    
                    Logger.log(.info("NFT minting simulated with gasUsed: \(response.gasInfo.gasUsed)"))
                    completion(.success(coins))
                    
                case .failure(let error):
                    Logger.log(.error(error))
                    completion(.failure(NSError(error) ?? error))
                }
            }
        )
    }
    
}

// MARK: - Burning

public extension NFT {
    
    static func burn(
        request: BurnRequest,
        mnemonic: Wallet.Mnemonic,
        fees: Imversed.Fee,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let connection = self.connection else {
            completion(.failure(Imversed.Error.notConfigured))
            return
        }

        Tx.performTransaction(
            channel: connection,
            route: Route.burn.path,
            message: request,
            fees: fees,
            mnemonic: mnemonic,
            completion: { result in
                switch result {
                case .success(let response):
                    if response.txResponse.code != 0 {
                        let txResponse = response.txResponse
                        let error = Imversed.Error.broadcastFailed(code: txResponse.code, log: txResponse.rawLog)

                        Logger.log(.error(error))
                        completion(.failure(error))
                    } else {
                        Logger.log(.info("Burn with txHash: \(response.txResponse.txhash)"))

                        TxListener.append(
                            waiting: .init(
                                txHash: response.txResponse.txhash,
                                completion: completion
                            )
                        )
                    }

                case .failure(let error):
                    Logger.log(.error(error))
                    completion(.failure(NSError(error) ?? error))
                }
            }
        )
    }

    static func simulate(
        burn request: BurnRequest,
        with mnemonic: Wallet.Mnemonic,
        feeDenom: Imversed.Coin.Denom,
        completion: @escaping (Result<Imversed.Fee, Error>) -> Void
    ) {
        guard let connection = self.connection else {
            completion(.failure(Imversed.Error.notConfigured))
            return
        }

        Tx.simulateTransaction(
            channel: connection,
            route: Route.burn.path,
            message: request,
            mnemonic: mnemonic,
            completion: { result in
                switch result {
                case .success(let response):
                    let coins = Utils.Estimate.getFees(
                        for: .burn,
                        denom: feeDenom,
                        gasUsed: response.gasInfo.gasUsed
                    )
                    
                    Logger.log(.info("NFT minting simulated with gasUsed: \(response.gasInfo.gasUsed)"))
                    completion(.success(coins))
                    
                case .failure(let error):
                    Logger.log(.error(error))
                    completion(.failure(NSError(error) ?? error))
                }
            }
        )
    }

}

