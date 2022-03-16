//
//  Logger.swift
//  Imversed
//
//  Created by Ilya S. on 29.12.2021.
//

import Foundation
import GRPC

public enum LogLevel: Int {
    case debug, info, warning, error
}

struct Logger {
    
}

// MARK: - Level

extension Logger {
    #if DEBUG
    static private var level: LogLevel = .info
    #else
    static private var level: LogLevel = .error
    #endif
    
    static func updateLog(level: LogLevel) {
        self.level = level
    }
}

// MARK: - Message

extension Logger {
    
    struct Message: CustomStringConvertible {
        let level: LogLevel
        let text: String
        
        var description: String {
            let prefix: String = {
                switch self.level {
                case .error:    return "⛔️"
                case .warning:  return "⚠️"
                case .info:     return "ℹ️"
                case .debug:    return "🛠"
                }
            }()
            
            return "Imversed: \(prefix) \(self.text)"
        }
        
        static func debug(_ text: String) -> Self {
            return .init(level: .debug, text: text)
        }
        
        static func info(_ text: String) -> Self {
            return .init(level: .info, text: text)
        }
        
        static func warning(_ text: String) -> Self {
            return .init(level: .warning, text: text)
        }
        
        static func error(_ text: String) -> Self {
            return .init(level: .error, text: text)
        }
        
        static func error(_ error: Error) -> Self {
            let text: String = {
                switch error {
                case let grpcStatus as GRPCStatus:
                    return "\(grpcStatus.message ?? "Undefined gRPC error") | code: \"\(grpcStatus.code)\""
                    
                default:
                    return error.localizedDescription
                }
            }()
            
            return .init(level: .error, text: text)
        }
    }
    
    static func log(_ message: Message) {
        guard message.level.rawValue >= self.level.rawValue else {
            return
        }
        
        NSLog(message.description)
    }
    
}
