//
//  Imversed+Tx.swift
//  Imversed
//
//  Created by Ilya S. on 03.12.2021.
//

import Foundation
import HDWalletKit
import SwiftProtobuf
import GRPC

struct Tx {
    static var connection: ClientConnection?
        
    private static let callOptions = CallOptions(logger: Logger.grpcLogger(label: "Tx"))
}

extension Tx {
    
    static func query(txHash: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let connection = self.connection else {
            completion(.failure(Imversed.Error.notConfigured))
            return
        }
        
        let client = Cosmos_Tx_V1beta1_ServiceClient(
            channel: connection, defaultCallOptions: self.callOptions
        )
        let request = Cosmos_Tx_V1beta1_GetTxRequest.with({
            $0.hash = txHash
        })
        client.getTx(request).response.whenComplete({ result in
            switch result {
            case .success(let response):
                if response.txResponse.code != 0 {
                    let txResponse = response.txResponse
                    let error = Imversed.Error.broadcastFailed(code: txResponse.code, log: txResponse.rawLog)

                    Logger.log(.error(error))
                    completion(.failure(NSError(error) ?? error))
                } else {
                    Logger.log(.info("Transaction finished txHash: \(response.txResponse.txhash)"))
                    completion(.success(()))
                }
                
            case .failure(let error):
                Logger.log(.error(error))
                completion(.failure(error))
            }
        })
    }
    
}

extension Tx {
    
    static func prepareSemiSignedTransaction(
        messages: [(route: String, legacy: String, message: TxMessage)],
        fees: Imversed.Fee,
        mnemonic: Wallet.Mnemonic,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let keys = try? mnemonic.getRawKeys() else {
            completion(.failure(Imversed.Error.invalidMnemonic))
            return
        }
        
        self.queryInfo(mnemonic: mnemonic, completion: { result in
            switch result {
            case .success(let environment):
                let semiSignedRawTx = self.prepareSemiSignedTransaction(
                    messages: messages,
                    fees: fees,
                    keys: keys,
                    environment: environment
                )
                completion(.success(semiSignedRawTx))
                
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    static func proceedPartialTransaction(
        channel: ClientConnection,
        data: Data,
        mnemonic: Wallet.Mnemonic,
        completion: @escaping (Result<Cosmos_Tx_V1beta1_BroadcastTxResponse, Error>) -> Void
    ) {
        guard let keys = try? mnemonic.getRawKeys() else {
            completion(.failure(Imversed.Error.invalidMnemonic))
            return
        }
        
        self.queryInfo(mnemonic: mnemonic, completion: { result in
            switch result {
            case .success(let environment):
                let client = Cosmos_Tx_V1beta1_ServiceClient(channel: channel, defaultCallOptions: self.callOptions)
                let request = self.complete(semiSigned: data, keys: keys, environment: environment)
                client.broadcastTx(request).response.whenComplete(completion)
                
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    static func performTransaction(
        channel: ClientConnection,
        route: String,
        message: TxMessage,
        fees: Imversed.Fee,
        mnemonic: Wallet.Mnemonic,
        completion: @escaping (Result<Cosmos_Tx_V1beta1_BroadcastTxResponse, Error>) -> Void
    ) {
        guard let messageData = try? message.content?.serializedData() else {
            completion(.failure(Imversed.Error.malformedData))
            return
        }
        
        guard let keys = try? mnemonic.getRawKeys() else {
            completion(.failure(Imversed.Error.invalidMnemonic))
            return
        }
        
        self.queryInfo(mnemonic: mnemonic, completion: { result in
            switch result {
            case .success(let environment):
                let client = Cosmos_Tx_V1beta1_ServiceClient(channel: channel, defaultCallOptions: self.callOptions)
                let request = self.request(
                    route: route, data: messageData, fees: fees, keys: keys, environment: environment
                )
                client.broadcastTx(request).response.whenComplete(completion)
                
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    static func simulateTransaction(
        channel: ClientConnection,
        route: String,
        message: TxMessage,
        mnemonic: Wallet.Mnemonic,
        completion: @escaping (Result<Cosmos_Tx_V1beta1_SimulateResponse, Error>) -> Void
    ) {
        guard let messageData = try? message.content?.serializedData() else {
            completion(.failure(Imversed.Error.malformedData))
            return
        }
        
        guard let keys = try? mnemonic.getRawKeys() else {
            completion(.failure(Imversed.Error.invalidMnemonic))
            return
        }
        
        self.queryInfo(mnemonic: mnemonic, completion: { result in
            switch result {
            case .success(let environment):
                let client = Cosmos_Tx_V1beta1_ServiceClient(channel: channel, defaultCallOptions: self.callOptions)
                let simulation = self.simulation(route: route, data: messageData, keys: keys, environment: environment)
                client.simulate(simulation).response.whenComplete(completion)
                
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
}

private extension Tx {
    
    typealias Environment = (node: Info.Node, account: Auth.Account)
    
    static func queryInfo(
        mnemonic: Wallet.Mnemonic,
        completion: @escaping (Result<Environment, Swift.Error>) -> Void
    ) {
        Info.queryNode(completion: { infoResult in
            switch infoResult {
            case .success(let nodeInfo):
                Auth.authorize(mnemonic: mnemonic, completion: { authResult in
                    switch authResult {
                    case .success(let accountInfo):
                        completion(.success((nodeInfo, accountInfo)))
                    
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
                
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    static func request(
        messages: [(route: String, data: Data)],
        fees: Imversed.Fee,
        keys: Wallet.Mnemonic.RawKeys,
        environment: Environment
    ) -> Cosmos_Tx_V1beta1_BroadcastTxRequest {
        let body = self.body(messages: messages)
        let signerInfo = self.signerInfo(publicKey: keys.public, sequence: environment.account.sequence)
        let authInfo = self.authInfo(signerInfo: signerInfo, fees: fees)
        
        let rawTx = self.rawTx(
            body: body,
            authInfo: authInfo,
            privateKey: keys.private,
            accountNumber: environment.account.number,
            network: environment.node.network
        )
        
        return Cosmos_Tx_V1beta1_BroadcastTxRequest.with({
            $0.mode = Cosmos_Tx_V1beta1_BroadcastMode.sync
            $0.txBytes = try! rawTx.serializedData()
        })
    }
    
    static func request(
        route: String,
        data: Data,
        fees: Imversed.Fee,
        keys: Wallet.Mnemonic.RawKeys,
        environment: Environment
    ) -> Cosmos_Tx_V1beta1_BroadcastTxRequest {
        let body = self.body(route: route, data: data)
        let signerInfo = self.signerInfo(publicKey: keys.public, sequence: environment.account.sequence)
        let authInfo = self.authInfo(signerInfo: signerInfo, fees: fees)
        
        let rawTx = self.rawTx(
            body: body,
            authInfo: authInfo,
            privateKey: keys.private,
            accountNumber: environment.account.number,
            network: environment.node.network
        )
        
        return Cosmos_Tx_V1beta1_BroadcastTxRequest.with({
            $0.mode = Cosmos_Tx_V1beta1_BroadcastMode.sync
            $0.txBytes = try! rawTx.serializedData()
        })
    }
    
    static func simulation(
        route: String,
        data: Data,
        keys: Wallet.Mnemonic.RawKeys,
        environment: Environment
    ) -> Cosmos_Tx_V1beta1_SimulateRequest {
        let body = self.body(route: route, data: data)
        let signerInfo = self.signerInfo(publicKey: keys.public, sequence: environment.account.sequence)
        let authInfo = Cosmos_Tx_V1beta1_AuthInfo.with({
            $0.fee = Cosmos_Tx_V1beta1_Fee()
            $0.signerInfos = [ signerInfo ]
        })
        
        let simulateTx = self.simulateTx(
            body: body,
            authInfo: authInfo,
            privateKey: keys.private,
            accountNumber: environment.account.number,
            network: environment.node.network
        )
        
        return Cosmos_Tx_V1beta1_SimulateRequest.with({
            $0.tx = simulateTx
        })
    }
    
    static func prepareSemiSignedTransaction(
        messages: [(route: String, legacy: String, message: TxMessage)],
        fees: Imversed.Fee,
        keys: Wallet.Mnemonic.RawKeys,
        environment: Environment
    ) -> Data {
        let body = self.body(messages: messages.compactMap({
            guard let data = try? $0.message.content?.serializedData() else {
                return nil
            }
            return ($0.route, data)
        }))
        
        let signerInfo = self.signerInfo(publicKey: keys.public, sequence: environment.account.sequence, legacy: true)
        let authInfo = self.authInfo(signerInfo: signerInfo, fees: fees)
        
        let signDoc = AminoSignDoc(
            account: environment.account,
            node: environment.node,
            fee: authInfo.fee,
            messages: messages.map({ ($0.legacy, $0.message) })
        )
        
        let signature = self.grpcByteSingleSignature(keys.private, try! signDoc.toJsonData())
        
        let rawTx = Cosmos_Tx_V1beta1_TxRaw.with({
            $0.bodyBytes = try! body.serializedData()
            $0.authInfoBytes = try! authInfo.serializedData()
            $0.signatures = [signature]
        })
        
        return try! rawTx.serializedData(partial: true)
    }
    
    static func complete(
        semiSigned partialTransaction: Data,
        keys: Wallet.Mnemonic.RawKeys,
        environment: Environment
    ) -> Cosmos_Tx_V1beta1_BroadcastTxRequest {
        var partialRawTx = try! Cosmos_Tx_V1beta1_TxRaw(serializedData: partialTransaction, partial: true)
        let body = try! Cosmos_Tx_V1beta1_TxBody(serializedData: partialRawTx.bodyBytes)
        var authInfo = try! Cosmos_Tx_V1beta1_AuthInfo(serializedData: partialRawTx.authInfoBytes)
        
        let signerInfo = self.signerInfo(publicKey: keys.public, sequence: environment.account.sequence)
        authInfo.signerInfos.append(signerInfo)
        
        let signDoc = Cosmos_Tx_V1beta1_SignDoc.with({
            $0.accountNumber = environment.account.number
            $0.chainID = environment.node.network
            $0.bodyBytes = try! body.serializedData()
            $0.authInfoBytes = try! authInfo.serializedData()
        })
        
        let hash = try! signDoc.serializedData().sha256()
        let signature = try! ECDSA.compactsign(hash, privateKey: keys.private)
        partialRawTx.signatures.append(signature)
        
        let completeRawTx = Cosmos_Tx_V1beta1_TxRaw.with({
            $0.bodyBytes = try! body.serializedData()
            $0.authInfoBytes = try! authInfo.serializedData()
            $0.signatures = partialRawTx.signatures
        })
        
        return Cosmos_Tx_V1beta1_BroadcastTxRequest.with({
            $0.mode = .sync
            $0.txBytes = try! completeRawTx.serializedData()
        })
    }
    
}

// MARK: - Helpers

private extension Tx {
    
    static func body(messages: [(route: String, data: Data)]) -> Cosmos_Tx_V1beta1_TxBody {
        let anyMessages = messages.map({ message in
            Google_Protobuf_Any.with({
                $0.typeURL = message.route
                $0.value = message.data
            })
        })
        return Cosmos_Tx_V1beta1_TxBody.with({
            $0.messages = anyMessages
        })
    }
    
    static func body(route: String, data: Data) -> Cosmos_Tx_V1beta1_TxBody {
        return self.body(messages: [(route, data)])
    }
    
    static func signerInfo(publicKey: Data, sequence: UInt64, legacy: Bool = false) -> Cosmos_Tx_V1beta1_SignerInfo {
        let pub = Cosmos_Crypto_Secp256k1_PubKey.with {
            $0.key = publicKey
        }
        let pubKey = Google_Protobuf_Any.with({
            $0.typeURL = "/cosmos.crypto.secp256k1.PubKey"
            $0.value = try! pub.serializedData()
        })
        let single = Cosmos_Tx_V1beta1_ModeInfo.Single.with {
            $0.mode = legacy ? .legacyAminoJson : .direct
        }
        let mode = Cosmos_Tx_V1beta1_ModeInfo.with {
            $0.single = single
        }
        
        return Cosmos_Tx_V1beta1_SignerInfo.with {
            $0.publicKey = pubKey
            $0.modeInfo = mode
            $0.sequence = sequence
        }
    }
    
    static func authInfo(
        signerInfo: Cosmos_Tx_V1beta1_SignerInfo,
        fees: Imversed.Fee
    ) -> Cosmos_Tx_V1beta1_AuthInfo {
        let coin = Cosmos_Base_V1beta1_Coin.with {
            $0.denom = fees.coins.denom
            $0.amount = String(describing: fees.coins.amount)
        }
        let txFee = Cosmos_Tx_V1beta1_Fee.with {
            $0.amount = [ coin ]
            $0.gasLimit = fees.gasLimit
        }
        
        return Cosmos_Tx_V1beta1_AuthInfo.with {
            $0.fee = txFee
            $0.signerInfos = [ signerInfo ]
        }
    }
    
    static func signDoc(
        body: Cosmos_Tx_V1beta1_TxBody,
        authInfo: Cosmos_Tx_V1beta1_AuthInfo,
        accountNumber: UInt64,
        network: String
    ) -> Cosmos_Tx_V1beta1_SignDoc {
        return Cosmos_Tx_V1beta1_SignDoc.with {
            $0.bodyBytes = try! body.serializedData()
            $0.authInfoBytes = try! authInfo.serializedData()
            $0.chainID = network
            $0.accountNumber = accountNumber
        }
    }
    
    static func grpcByteSingleSignature(_ privateKey: Data, _ toSignByte: Data) -> Data {
        let hash = toSignByte.sha256()
        let signedData = try! ECDSA.compactsign(hash, privateKey: privateKey)
        return signedData
    }
    
    static func rawTx(
        body: Cosmos_Tx_V1beta1_TxBody,
        authInfo: Cosmos_Tx_V1beta1_AuthInfo,
        privateKey: Data,
        accountNumber: UInt64,
        network: String
    ) -> Cosmos_Tx_V1beta1_TxRaw {
        let signDoc = self.signDoc(body: body, authInfo: authInfo, accountNumber: accountNumber, network: network)
        let signature = self.grpcByteSingleSignature(privateKey, try! signDoc.serializedData())
        
        return Cosmos_Tx_V1beta1_TxRaw.with {
            $0.bodyBytes = try! body.serializedData()
            $0.authInfoBytes = try! authInfo.serializedData()
            $0.signatures = [ signature ]
        }
    }
    
    static func simulateTx(
        body: Cosmos_Tx_V1beta1_TxBody,
        authInfo: Cosmos_Tx_V1beta1_AuthInfo,
        privateKey: Data,
        accountNumber: UInt64,
        network: String
    ) -> Cosmos_Tx_V1beta1_Tx {
        let signDoc = self.signDoc(body: body, authInfo: authInfo, accountNumber: accountNumber, network: network)
        let signature = self.grpcByteSingleSignature(privateKey, try! signDoc.serializedData())
        
        return Cosmos_Tx_V1beta1_Tx.with {
            $0.authInfo = authInfo
            $0.body = body
            $0.signatures = [ signature ]
        }
    }
        
}
