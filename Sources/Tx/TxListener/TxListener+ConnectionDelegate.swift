//
//  TxListener+ConnectionDelegate.swift
//  Imversed
//
//  Created by Ilya S. on 22.02.2022.
//

import Foundation

extension TxListener {
    
    final class ConnectionDelegate: NSObject, URLSessionWebSocketDelegate {
        enum Connection {
            case opened, failed
        }
        
        var onConnectionUpdate: ((Connection) -> Void)?
        
        func urlSession(
            _ session: URLSession,
            webSocketTask: URLSessionWebSocketTask,
            didOpenWithProtocol protocol: String?
        ) {
            self.onConnectionUpdate?(.opened)
        }
        
        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            if error != nil {
                self.onConnectionUpdate?(.failed)
            }
        }
        
    }
    
}
