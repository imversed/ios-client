//
//  Imversed+Wallet.swift
//  Imversed
//
//  Created by Ilya S. on 03.12.2021.
//

import Foundation
import HDWalletKit

public struct Wallet {
    public typealias CosmAddress = String
    public typealias EthAddress = String
    
    private init() { }
}


public extension Wallet {
    
    static func generateMnemonic() -> Mnemonic {
        let phrase = HDWalletKit.Mnemonic.create(strength: .hight, language: .english)
        return .init(phrase: phrase)
    }
    
}
