//
//  Imversed+Coin.swift
//  Imversed
//
//  Created by Ilya S. on 03.12.2021.
//

import Foundation

public extension Imversed {
    
    struct Coin: Codable {
        public typealias Denom = String
        public typealias Value = Decimal
        
        public let amount: Value
        public let denom: Denom
        
        public init(amount: Value, denom: Denom) {
            self.amount = amount
            self.denom = denom
        }
    }
    
}

public extension Imversed.Coin.Value {
    
    init?(string: String) {
        let sanitized = string.replacingOccurrences(of: ",", with: ".")
        self.init(string: sanitized, locale: nil)
    }
    
}

extension Imversed.Coin: Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.denom != rhs.denom {
            return false
        }
        return lhs.amount < rhs.amount
    }
    
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        if lhs.denom != rhs.denom {
            return false
        }
        return lhs.amount <= rhs.amount
    }
    
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        if lhs.denom != rhs.denom {
            return false
        }
        return lhs.amount >= rhs.amount
    }
    
    public static func > (lhs: Self, rhs: Self) -> Bool {
        if lhs.denom != rhs.denom {
            return false
        }
        return lhs.amount > rhs.amount
    }
    
}

public extension Imversed.Coin {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let rawDecimalAmount = try? container.decode(Value.self, forKey: .amount) {
            self.amount = rawDecimalAmount
        } else if let rawStringAmount = try? container.decode(String.self, forKey: .amount),
           let amount = Value(string: rawStringAmount) {
            self.amount = amount
        } else if let rawIntAmount = try? container.decode(Int.self, forKey: .amount) {
            self.amount = Value(rawIntAmount)
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .amount, in: container, debugDescription: "Failed cast amount value"
            )
        }
        
        self.denom = try container.decode(Denom.self, forKey: .denom)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let rawAmount = String(describing: self.amount)
        try container.encode(rawAmount, forKey: .amount)
        try container.encode(self.denom, forKey: .denom)
    }
    
    enum CodingKeys: String, CodingKey {
        case amount
        case denom
    }
    
}

extension Imversed.Coin {
    
    init(cosmos coin: Cosmos_Base_V1beta1_Coin) throws {
        guard let amount = Value(string: coin.amount) else {
            throw Imversed.Error.malformedData
        }
        
        self.amount = amount
        self.denom = coin.denom
    }
    
}
