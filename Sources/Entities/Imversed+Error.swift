//
//  Imversed+Error.swift
//  Imversed
//
//  Created by Ilya S. on 03.12.2021.
//

import Foundation

public extension Imversed {
    
    enum Error: Swift.Error {
        case notConfigured
        case invalidMnemonic
        case malformedData
        
        case malformedEstimatesConfiguration(Any)
        
        case broadcastFailed(code: UInt32, log: String)
    }
    
}

extension Imversed.Error: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .notConfigured:
            return "Call Imversed.configure(connection:configuration:) before calling this method"

        case .invalidMnemonic:
            return "Unable to parse provided mnemonic"

        case .malformedData:
            return "Malformed data provided"

        case .malformedEstimatesConfiguration(let obj):
            return "Malformed estimates data: \(obj)"

        case .broadcastFailed(code: let code, log: let log):
            return "Code \(code) | log: \(log)"
        }
    }
    
}
