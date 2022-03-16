//
//  Imversed+Utils+Gas.swift
//  Imversed
//
//  Created by Ilya S. on 06.12.2021.
//

import Foundation

extension Utils {
    
    public struct Estimate {
        public enum Operation: String {
            case sendCoins
            case mintNft
            case transferNft
            case burn
        }
        
        public static func getFees(for operations: [Operation], denom: Imversed.Coin.Denom) -> Imversed.Fee {
            let gases = operations.map({ self.getFees(for: $0, denom: denom) })
            let amount = gases.reduce(0, { $0 + $1.coins.amount })
            let limit: UInt64 = gases.reduce(0, { $0 + $1.gasLimit })
            
            return .init(coins: .init(amount: amount, denom: denom), limit: limit)
        }
        
        public static func getFees(
            for operation: Operation,
            denom: Imversed.Coin.Denom,
            gasUsed: UInt64? = nil
        ) -> Imversed.Fee {
            let configuration = self.configurations[operation] ?? .default
            let gasUsed = gasUsed ?? configuration.limit
            
            var gasUsedPrice = configuration.price * Decimal(gasUsed)
            var gasUsedRounded = Decimal()
            NSDecimalRound(&gasUsedRounded, &gasUsedPrice, 6, .bankers)
            
            var maximumPrice = configuration.price * Decimal(configuration.limit)
            var maximumPriceRounded = Decimal()
            NSDecimalRound(&maximumPriceRounded, &maximumPrice, 6, .bankers)
            
            let amount = max(gasUsedRounded, maximumPriceRounded)
            return .init(coins: .init(amount: amount, denom: denom), limit: configuration.limit)
        }
    }
    
}

extension Utils.Estimate {
    
    static var configurations: [Operation: Configuration] = [:]
    
    struct Configuration {
        let price: Imversed.Coin.Value
        let limit: UInt64
        
        static let `default` = Configuration(price: 0.001, limit: 200_000)
        
        private init(price: Imversed.Coin.Value, limit: UInt64) {
            self.price = price
            self.limit = limit
        }
        
        init?(with dictionary: [String: Any]) {
            guard
                let limit = dictionary["limit"] as? UInt64,
                let rawPrice = dictionary["price"] as? String,
                let price = Imversed.Coin.Value(string: rawPrice)
            else {
                return nil
            }
            
            self.price = price
            self.limit = limit
        }
    }
    
    // example json: [{"operation":"sendCoins","gas":{"price":"0.001","limit":100000}}]
    static func updateConfiguration(with jsonString: String) {
        do {
            guard let data = jsonString.data(using: .utf8) else {
                throw Imversed.Error.malformedEstimatesConfiguration(jsonString)
            }
            
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let jsonArray = jsonObject as? [[String: Any]] else {
                throw Imversed.Error.malformedEstimatesConfiguration(jsonObject)
            }
            
            for element in jsonArray {
                guard
                    let operationRaw = element["operation"] as? String,
                    let operation = Operation(rawValue: operationRaw),
                    let gas = element["gas"] as? [String: Any],
                    let configuration = Configuration(with: gas)
                else { continue }
                
                self.configurations[operation] = configuration
            }
            Logger.log(.info("Gas estimates configuration successfully updated"))
            
        } catch {
            Logger.log(.error(error))
        }
    }
    
}
