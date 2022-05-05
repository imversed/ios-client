//
//  Imversed+Bank.swift
//  Imversed
//
//  Created by Ilya S. on 03.12.2021.
//

import Foundation
import GRPC
import SwiftProtobuf

public struct Bank {
    static var connection: ClientConnection?
    
    private static let callOptions = CallOptions(logger: Logger.grpcLogger(label: "Bank"))
}

// MARK: - Query

public extension Bank {
    
    static func queryBalance(
        mnemonic: Wallet.Mnemonic,
        denom: Imversed.Coin.Denom,
        completion: @escaping (Result<Imversed.Coin, Error>) -> Void
    ) {
        do {
            let address = try mnemonic.getCosmosAddress()
            self.queryBalance(address: address, denom: denom, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    static func queryBalance(
        address: Wallet.CosmAddress,
        denom: Imversed.Coin.Denom,
        completion: @escaping (Result<Imversed.Coin, Error>) -> Void
    ) {
        guard let connection = self.connection else {
            completion(.failure(Imversed.Error.notConfigured))
            return
        }

        let client = Cosmos_Bank_V1beta1_QueryClient(channel: connection, defaultCallOptions: self.callOptions)
        let request = Cosmos_Bank_V1beta1_QueryBalanceRequest.with({
            $0.denom = denom
            $0.address = address
        })

        client.balance(request).response.whenComplete({ result in
            switch result {
            case .success(let response):
                do {
                    let coin = try Imversed.Coin(cosmos: response.balance)

                    Logger.log(.info("Address: \(address) balance: \(coin)"))
                    completion(.success(coin))
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
        
}

// MARK: - Tx

extension Bank {
    
    enum Route {
        case sendCoins
        
        var path: String {
            switch self {
            case .sendCoins: return "/cosmos.bank.v1beta1.MsgSend"
            }
        }
        
        var legacy: String {
            switch self {
            case .sendCoins: return "cosmos-sdk/MsgSend"
            }
        }
    }
    
}

// MARK: Sending coins

public extension Bank {
    
    static func transaction(
        sendCoins request: SendRequest,
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
            route: Route.sendCoins.path,
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
                        completion(.failure(NSError(error) ?? error))
                    } else {
                        Logger.log(.info("Transaction txHash: \(response.txResponse.txhash)"))
                        
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
        sendCoins request: SendRequest,
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
            route: Route.sendCoins.path,
            message: request,
            mnemonic: mnemonic,
            completion: { result in
                switch result {
                case .success(let response):
                    let coins = Utils.Estimate.getFees(
                        for: .sendCoins,
                        denom: feeDenom,
                        gasUsed: response.gasInfo.gasUsed
                    )
                    
                    Logger.log(.info("Simulation gasUsed: \(response.gasInfo.gasUsed)"))
                    completion(.success(coins))
                    
                case .failure(let error):
                    Logger.log(.error(error))
                    completion(.failure(NSError(error) ?? error))
                }
            }
        )
    }
    
}
