//
//  NSError.swift
//  Imversed
//
//  Created by Ilya S. on 02.02.2022.
//

import Foundation
import NIOCore
import GRPC

public enum ImversedErrorCodes: Int {
    case notConnectedToInternet = 1000
    case invalidArgument        = 1001
}

extension NSError {
    
    convenience init?(_ error: Error) {
        switch error {
        case let grpc as GRPCStatus:
            let code: Int = {
                switch grpc.code {
                case .invalidArgument:
                    return ImversedErrorCodes.invalidArgument.rawValue
                    
                default:
                    return grpc.code.rawValue
                }
            }()
            
            self.init(
                domain: "Imversed",
                code: code,
                userInfo: [ NSLocalizedDescriptionKey: grpc.message ?? "Unknown" ]
            )
            
        case let channel as NIOCore.ChannelError:
            switch channel {
            case .connectTimeout:
                self.init(
                    domain: "Imversed",
                    code: ImversedErrorCodes.notConnectedToInternet.rawValue,
                    userInfo: [ NSLocalizedDescriptionKey: "The Internet connection appears to be offline." ]
                )
                
            default:
                return nil
            }
            
        default:
            return nil
        }
    }
    
}
