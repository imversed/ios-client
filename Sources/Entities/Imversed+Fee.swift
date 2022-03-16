//
//  Imversed+Fee.swift
//  Imversed
//
//  Created by Ilya S. on 03.12.2021.
//

import Foundation

public extension Imversed {
    
    struct Fee {
        public let coins: Imversed.Coin
        public let gasLimit: UInt64
        
        public init(coins: Imversed.Coin, limit: UInt64) {
            self.coins = coins
            self.gasLimit = limit
        }
    }
    
}
