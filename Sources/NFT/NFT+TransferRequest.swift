//
//  Imversed+NFT+TransferRequest.swift
//  Imversed
//
//  Created by Ilya S. on 15.12.2021.
//

import Foundation

public extension NFT {
    
    class TransferRequest: TxMessage {
        private let doNotModifyValue = "[do-not-modify]"
        
        let token: Imversed.Token
        let recipient: Wallet.CosmAddress
        
        public init(token: Imversed.Token, recipient: Wallet.CosmAddress) {
            self.token = token
            self.recipient = recipient
        }
        
        override var content: Content? {
            return Imversed_Nft_MsgTransferNFT.with({
                $0.id = self.token.id
                $0.denomID = self.token.denom
                $0.name = self.doNotModifyValue
                $0.uri = self.doNotModifyValue
                $0.data = self.doNotModifyValue
                $0.sender = self.token.owner
                $0.recipient = self.recipient
            })
        }
        
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.token.id, forKey: .id)
            try container.encode(self.token.denom, forKey: .denomId)
            try container.encode(self.doNotModifyValue, forKey: .name)
            try container.encode(self.doNotModifyValue, forKey: .uri)
            try container.encode(self.doNotModifyValue, forKey: .data)
            try container.encode(self.token.owner, forKey: .sender)
            try container.encode(self.recipient, forKey: .recipient)
        }
    }
    
}

extension NFT.TransferRequest {
    
    enum CodingKeys: String, CodingKey {
        case id         = "id"
        case denomId    = "denom_id"
        case name       = "name"
        case uri        = "uri"
        case data       = "data"
        case sender     = "sender"
        case recipient  = "recipient"
    }
    
}
