//
//  Wallet+Mnemonic.swift
//  Imversed
//
//  Created by Ilya S. on 22.12.2021.
//

import Foundation
import HDWalletKit

public extension Wallet {
    
    struct Mnemonic {
        public typealias Word = String

        public static var availableWords: [String] {
            return WordList.english.words
        }

        public let words: [Word]
        
        public var phrase: String {
            return self.words.joined(separator: " ")
        }

        public init(words: [Word]) {
            self.words = words
        }
        
        public init(phrase: String) {
            self.words = phrase.components(separatedBy: " ")
        }
        
        public var address: Wallet.Address? {
            return try? self.getPublicAddress()
        }
    }
    
}

public extension Wallet.Mnemonic {

    func getAddress() throws -> Wallet.Address {
        guard let address = self.address else {
            throw NSError(
                domain: String(describing: type(of: self)),
                code: -1,
                userInfo: [ NSLocalizedDescriptionKey: "Failed to convert mnemonic to address" ]
            )
        }

        return address
    }

}

extension Wallet.Mnemonic {
    
    typealias RawKeys = (`private`: Data, `public`: Data)
    
    func getRawKeys() throws -> RawKeys {
        let privateKey = self.getHDKey().raw
        let publicKey = self.getHDKey().publicKey.data
        
        return (privateKey, publicKey)
    }
    
}

extension Wallet.Mnemonic {
    
    func getHDKey() -> PrivateKey {
        let phrase = self.words.joined(separator: " ")
        let master = PrivateKey(seed: HDWalletKit.Mnemonic.createSeed(mnemonic: phrase), coin: .bitcoin)
        
        return master
            .derived(at: .hardened(44))
            .derived(at: .hardened(118))
            .derived(at: .hardened(0))
            .derived(at: .notHardened(0))
            .derived(at: .notHardened(0))
    }
    
    func getPublicAddress() throws -> Wallet.Address {
        let hdKey = self.getHDKey()
        let hex = hdKey.publicKey.data.toHexString()

        guard let sha256 = Data.fromHex(hex)?.sha256() else {
            throw HDWalletKitError.unknownError
        }

        let ripemd160 = RIPEMD160.hash(sha256)
        return try SegwitAddrCoder.shared.encode2(hrp: "imv", program: ripemd160)
    }

}
