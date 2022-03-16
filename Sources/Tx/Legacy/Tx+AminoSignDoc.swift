//
//  Tx+AminoSignDoc.swift
//  Imversed
//
//  Created by Ilya S. on 29.12.2021.
//

import Foundation

extension Tx {
    
    struct AminoSignDoc: Encodable {
        struct Coin: Encodable {
            let denom: String
            let amount: String
        }
        
        struct Fee: Encodable {
            let amount: [Coin]
            let gas: String
        }
        
        struct AminoMsg: Encodable {
            let type: String
            let value: TxMessage
        }
        
        let accountNumber: String
        let sequence: String
        let chainId: String
        let memo: String = ""
        let fee: Fee
        let messages: [AminoMsg]
        
        init(
            account: Auth.Account,
            node: Info.Node,
            fee: Cosmos_Tx_V1beta1_Fee,
            messages: [(legacy: String, message: TxMessage)]
        ) {
            self.accountNumber = String(account.number)
            self.sequence = String(account.sequence)
            self.chainId = node.network
            self.fee = .init(
                amount: fee.amount.map({ .init(denom: $0.denom, amount: $0.amount) }),
                gas: String(fee.gasLimit)
            )
            self.messages = messages.map({ .init(type: $0.legacy, value: $0.message) })
        }
    }
    
}

extension Tx.AminoSignDoc {
    
    func toJsonData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [ .sortedKeys, .withoutEscapingSlashes ]
        return try encoder.encode(self)
    }
    
}

private extension Tx.AminoSignDoc {
    
    enum CodingKeys: String, CodingKey {
        case accountNumber  = "account_number"
        case sequence       = "sequence"
        case chainId        = "chain_id"
        case memo           = "memo"
        case fee            = "fee"
        case messages       = "msgs"
    }
    
}

private extension Tx.AminoSignDoc.AminoMsg {
    
    enum CodingKeys: String, CodingKey {
        case type   = "type"
        case value  = "value"
    }
    
}

private extension Tx.AminoSignDoc.Fee {
    
    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case gas    = "gas"
    }
    
}

private extension Tx.AminoSignDoc.Coin {
    
    enum CodingKeys: String, CodingKey {
        case denom  = "denom"
        case amount = "amount"
    }
    
}
