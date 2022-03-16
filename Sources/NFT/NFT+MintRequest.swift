//
//  Imversed+NFT+MintRequest.swift
//  Imversed
//
//  Created by Ilya S. on 06.12.2021.
//

import Foundation

public extension NFT {
    
    class MintRequest: TxMessage {
        let token: Imversed.Token
        
        public init(token: Imversed.Token) {
            self.token = token
        }
        
        override var content: Content? {
            guard
                let payloadData = try? JSONSerialization.data(withJSONObject: self.token.payload, options: []),
                let payloadJson = String(data: payloadData, encoding: .utf8)
            else {
                return nil
            }
            
            return Imversed_Nft_MsgMintNFT.with({
                $0.id = self.token.id
                $0.denomID = self.token.denom
                $0.name = self.token.name
                $0.uri = self.token.url.absoluteString
                $0.data = payloadJson
                $0.sender = self.token.owner
                $0.recipient = self.token.owner
            })
        }
        
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.token.id, forKey: .id)
            try container.encode(self.token.denom, forKey: .denomId)
            try container.encode(self.token.name, forKey: .name)
            try container.encode(self.token.url.absoluteString, forKey: .uri)
            try container.encode(self.token.owner, forKey: .sender)
            try container.encode(self.token.owner, forKey: .recipient)
            
            let payloadData = try JSONSerialization.data(withJSONObject: self.token.payload, options: [ ])
            let payloadJson = String(data: payloadData, encoding: .utf8)
            try container.encode(payloadJson, forKey: .data)
        }
    }
    
}

extension NFT.MintRequest {
    
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
