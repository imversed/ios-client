//
//  Imversed+Complex.swift
//  Imversed
//
//  Created by Ilya S. on 15.12.2021.
//

import Foundation
import GRPC

public struct Complex {
    static var connection: ClientConnection?
}

// MARK: - Buying NFT

public extension Complex {
    
    struct BidTransaction {
        let transfer: NFT.TransferRequest
        let sendCoins: Bank.SendRequest
        
        public init(transfer: NFT.TransferRequest, sendCoins: Bank.SendRequest) {
            self.transfer = transfer
            self.sendCoins = sendCoins
        }
    }
    
    static func simulate(
        bidTransaction: BidTransaction,
        with mnemonic: Wallet.Mnemonic,
        feeDenom: Imversed.Coin.Denom,
        completion: @escaping (Result<Imversed.Fee, Error>) -> Void
    ) {
        let estimatedFees = Utils.Estimate.getFees(for: [ .transferNft, .sendCoins ], denom: feeDenom)
        completion(.success(estimatedFees))
    }
    
    static func prepare(
        bidTransaction: BidTransaction,
        with mnemonic: Wallet.Mnemonic,
        fees: Imversed.Fee,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        Tx.prepareSemiSignedTransaction(
            messages: [
                (Bank.Route.sendCoins.path, Bank.Route.sendCoins.legacy, bidTransaction.sendCoins),
                (NFT.Route.transfer.path, NFT.Route.transfer.legacy, bidTransaction.transfer)
            ],
            fees: fees,
            mnemonic: mnemonic,
            completion: { result in
                switch result {
                case .success(let data):
                    Logger.log(.info("Transaction prepared"))
                    completion(.success(data))

                case .failure(let error):
                    Logger.log(.error(error))
                    completion(.failure(NSError(error) ?? error))
                }
            }
        )
    }
        
}

// MARK: - Common

public extension Complex {
    
    static func proceed(
        partial rawTransaction: Data,
        with mnemonic: Wallet.Mnemonic,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let connection = self.connection else {
            completion(.failure(Imversed.Error.notConfigured))
            return
        }
        
        Tx.proceedPartialTransaction(
            channel: connection,
            data: rawTransaction,
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
                        Logger.log(.info("Partial transaction finished txHash: \(response.txResponse.txhash)"))
                        
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
    
}
