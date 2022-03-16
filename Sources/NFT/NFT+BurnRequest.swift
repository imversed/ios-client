//
//  NFT+BurnRequest.swift
//  Imversed
//
//  Created by Ilya S. on 13.03.2022.
//

import Foundation

public extension NFT {

    class BurnRequest: TxMessage {
        let token: Imversed.Token

        public init(token: Imversed.Token) {
            self.token = token
        }

        override var content: TxMessage.Content? {
            return Imversed_Nft_MsgBurnNFT.with({
                $0.id = self.token.id
                $0.denomID = self.token.denom
                $0.sender = self.token.owner
            })
        }
    }
    
}

extension NFT.BurnRequest {
    
    enum CodingKeys: String, CodingKey {
        case id         = "id"
        case denomID    = "denom_id"
        case sender     = "sender"
    }
    
}
