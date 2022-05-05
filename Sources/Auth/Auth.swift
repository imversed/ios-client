//
//  Imversed+Auth.swift
//  Imversed
//
//  Created by Ilya S. on 03.12.2021.
//

import Foundation
import GRPC

struct Auth {
    static var connection: ClientConnection?
    
    private static let callOptions = CallOptions(logger: Logger.grpcLogger(label: "Auth"))
}

extension Auth {
    
    struct Account {
        let address: Wallet.CosmAddress
        let number: UInt64
        let sequence: UInt64
    }
    
    static func authorize(
        mnemonic: Wallet.Mnemonic,
        completion: @escaping (Result<Account, Error>) -> Void
    ) {
        guard let connection = self.connection else {
            completion(.failure(Imversed.Error.notConfigured))
            return
        }
        
        guard let address = mnemonic.address else {
            completion(.failure(Imversed.Error.invalidMnemonic))
            return
        }
        
        let client = Cosmos_Auth_V1beta1_QueryClient(channel: connection, defaultCallOptions: self.callOptions)
        let request = Cosmos_Auth_V1beta1_QueryAccountRequest.with({
            $0.address = address
        })
        client.account(request).response.whenComplete({ result in
            switch result {
            case .success(let response):
                do {
                    let account = try self.parse(account: response)
                    
                    Logger.log(.info("Address: \(account.address) number: \(account.number) seq: \(account.sequence)"))
                    completion(.success(account))
                } catch {
                    Logger.log(.error(error))
                    completion(.failure(error))
                }
                
            case .failure(let error):
                Logger.log(.error(error))
                completion(.failure(error))
            }
        })
    }
    
}

private extension Auth {
    
    static func parse(account response: Cosmos_Auth_V1beta1_QueryAccountResponse) throws -> Account {
        let typeUrl = response.account.typeURL
        let accountData = response.account.value
        
        if (typeUrl.contains(Cosmos_Auth_V1beta1_BaseAccount.protoMessageName)) {
            let auth = try Cosmos_Auth_V1beta1_BaseAccount(serializedData: response.account.value)
            return Account(address: auth.address, number: auth.accountNumber, sequence: auth.sequence)
            
        } else if (typeUrl.contains(Cosmos_Vesting_V1beta1_PeriodicVestingAccount.protoMessageName)) {
            let auth = try Cosmos_Vesting_V1beta1_PeriodicVestingAccount(
                serializedData: accountData
            ).baseVestingAccount.baseAccount
            
            return Account(address: auth.address, number: auth.accountNumber, sequence: auth.sequence)
        } else if (typeUrl.contains(Cosmos_Vesting_V1beta1_ContinuousVestingAccount.protoMessageName)) {
            let auth = try Cosmos_Vesting_V1beta1_ContinuousVestingAccount(
                serializedData: accountData
            ).baseVestingAccount.baseAccount
            
            return Account(address: auth.address, number: auth.accountNumber, sequence: auth.sequence)
        } else if (typeUrl.contains(Cosmos_Vesting_V1beta1_DelayedVestingAccount.protoMessageName)) {
            let auth = try Cosmos_Vesting_V1beta1_DelayedVestingAccount(
                serializedData: accountData
            ).baseVestingAccount.baseAccount
            
            return Account(address: auth.address, number: auth.accountNumber, sequence: auth.sequence)
        } else {
            throw Imversed.Error.malformedData
        }
    }
    
}
