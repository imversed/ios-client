//
//  Logger+GRPC.swift
//  Imversed
//
//  Created by Ilya S. on 29.12.2021.
//

import Foundation
import Logging
import GRPC

extension Logger {
    
    static func grpcLogger(label: String) -> Logging.Logger {
        return Logging.Logger(label: label, factory: { GRPCLogHandler(label: $0) })
    }
    
    struct GRPCLogHandler: LogHandler {
        let label: String
        
        var metadata: Logging.Logger.Metadata = .init()
        var logLevel: Logging.Logger.Level = .debug
        
        subscript(metadataKey metadataKey: String) -> Logging.Logger.Metadata.Value? {
            get { return self.metadata[metadataKey] }
            set { self.metadata[metadataKey] = newValue }
        }
                
        func log(
            level: Logging.Logger.Level,
            message: Logging.Logger.Message,
            metadata: Logging.Logger.Metadata?,
            source: String,
            file: String,
            function: String,
            line: UInt
        ) {
            let text = "[\(self.label)] \(message.description)"
            switch level {
            case .debug:            Logger.log(.debug(text))
            case .info, .notice:    Logger.log(.info(text))
            case .warning:          Logger.log(.warning(text))
            case .error, .critical: Logger.log(.error(text))
            
            case .trace: break
            }
        }
    }
    
}

extension Logger {
    
    class ConnectivityErrorHandler: ClientErrorDelegate {
        func didCatchError(_ error: Error, logger: Logging.Logger, file: StaticString, line: Int) {
            Logger.log(.error(error))
        }
    }
    
    class ConnectivityStateHandler: ConnectivityStateDelegate {
        func connectivityStateDidChange(from oldState: ConnectivityState, to newState: ConnectivityState) {
            let message = "Connectivity state changed from \(oldState) to \(newState)"
            
            switch newState {
            case .idle, .connecting, .ready:    Logger.log(.info(message))
            case .transientFailure:             Logger.log(.error(message))
            case .shutdown:                     Logger.log(.warning(message))
            }
        }
    }
    
}
