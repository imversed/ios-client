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
        
        public var address: Wallet.CosmAddress? {
            return try? self.getCosmosAddress()
        }
        
        public var ethAddress: Wallet.EthAddress {
            return self.getEtheriumAddress()
        }
    }
    
}

public extension Wallet.Mnemonic {
    
    func getCosmosAddress() throws -> Wallet.CosmAddress {
        var address = self.ethAddress
        if (address.starts(with: "0x")) {
            address = address.replacingOccurrences(of: "0x", with: "")
        }
        
        guard let idata = Data.fromHex(address) else {
            throw NSError(
                domain: String(describing: type(of: self)),
                code: -1,
                userInfo: [ NSLocalizedDescriptionKey: "Failed to convert etherium address to cosmos" ]
            )
        }
        
        do {
            let converted = try Bech32.convertBits(from: 8, to: 5, pad: true, idata: idata)
            return Bech32().encode("imv", values: converted)
        } catch {
            throw error
        }
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
        let master = PrivateKey(seed: HDWalletKit.Mnemonic.createSeed(mnemonic: phrase), coin: .ethereum)
        
        return master
            .derived(at: .hardened(44))
            .derived(at: .hardened(60))
            .derived(at: .hardened(0))
            .derived(at: .notHardened(0))
            .derived(at: .notHardened(0))
    }
    
    func getEtheriumAddress() -> Wallet.EthAddress {
        let hdKey = self.getHDKey()
        let uncompressedPubKey = HDWalletKit.Crypto.generatePublicKey(data: hdKey.raw, compressed: false)
        
        var pub = Data(count: 64)
        pub = uncompressedPubKey.subdata(in: (1..<65))
        
        let eth = HDWalletKit.Crypto.sha3keccak256(data: pub)
        var address = Data(count: 20)
        address = eth.subdata(in: (12..<32))
        
        return EthereumAddress.init(data: address).string
    }

}
