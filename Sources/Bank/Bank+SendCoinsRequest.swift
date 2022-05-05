//
//  Imversed+Bank+SendCoins.swift
//  Imversed
//
//  Created by Ilya S. on 06.12.2021.
//

import Foundation
import GRPC

public extension Bank {
    
    final class SendRequest: TxMessage {
        let coins: Imversed.Coin
        let owner: Wallet.CosmAddress
        let recipient: Wallet.CosmAddress
        
        public init(coins: Imversed.Coin, owner: Wallet.CosmAddress, recipient: Wallet.CosmAddress) {
            self.coins = coins
            self.owner = owner
            self.recipient = recipient
        }
        
        override var content: Content? {
            let coins = Cosmos_Base_V1beta1_Coin.with({
                $0.denom = self.coins.denom
                $0.amount = String(describing: self.coins.amount)
            })
            
            return Cosmos_Bank_V1beta1_MsgSend.with({
                $0.amount = [ coins ]
                $0.fromAddress = self.owner
                $0.toAddress = self.recipient
            })
        }
        
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode([self.coins], forKey: .coins)
            try container.encode(self.owner, forKey: .owner)
            try container.encode(self.recipient, forKey: .recipient)
        }
    }
    
}

extension Bank.SendRequest {
    
    enum CodingKeys: String, CodingKey {
        case coins      = "amount"
        case owner      = "from_address"
        case recipient  = "to_address"
    }
    
}
