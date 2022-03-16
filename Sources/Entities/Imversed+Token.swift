//
//  Imversed+Token.swift
//  Imversed
//
//  Created by Ilya S. on 14.12.2021.
//

import Foundation

public extension Imversed {
    
    struct Token {
        public typealias Identifier = String
        public typealias Denom = String
        
        public let id: Identifier
        public let denom: Denom
        public let name: String
        public let url: URL
        public let owner: Wallet.Address
        public let payload: [String: Any]
        
        public init(
            id: Identifier,
            denom: Denom,
            name: String,
            url: URL,
            owner: Wallet.Address,
            payload: [String: Any]
        ) {
            self.id = id
            self.denom = denom
            self.name = name
            self.url = url
            self.owner = owner
            self.payload = payload
        }
    }
    
}

extension Imversed.Token {
    
    init(imversed nft: Imversed_Nft_BaseNFT, denom: Denom) throws {
        guard
            let url = URL(string: nft.uri),
            let payloadData = nft.data.data(using: .utf8),
            let payload = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any]
        else {
            throw Imversed.Error.malformedData
        }
        
        self.id = nft.id
        self.denom = denom
        self.name = nft.name
        self.url = url
        self.owner = nft.owner
        self.payload = payload
    }
        
}

extension Imversed.Token: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case id         = "id"
        case name       = "name"
        case url        = "uri"
        case owner      = "owner"
        case payload    = "data"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.url, forKey: .url)
        try container.encode(self.owner, forKey: .owner)
        
        let rawData = try JSONSerialization.data(withJSONObject: self.payload, options: [ .fragmentsAllowed ])
        let payloadJson = String(data: rawData, encoding: .utf8)
        
        try container.encode(payloadJson, forKey: .payload)
    }
    
}
