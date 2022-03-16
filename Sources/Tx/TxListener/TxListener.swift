//
//  TxListener.swift
//  Imversed
//
//  Created by Ilya S. on 14.02.2022.
//

import Foundation

struct TxListener {
    private static let connectionDelegate = ConnectionDelegate()
    private static let retriesMax: Int = 3
    private static var retries: Int = 0
    
    private static var urlSession: URLSession {
        return URLSession(configuration: .default, delegate: self.connectionDelegate, delegateQueue: OperationQueue())
    }
    
    private static var task: URLSessionWebSocketTask? {
        didSet {
            self.task?.receive(completionHandler: self.handleInbound(_:))
            self.task?.resume()
        }
    }
        
    static func start(host: String, port: Int) {
        guard let url = URL(string: "ws://\(host):\(port)/websocket") else {
            return
        }
        
        self.connectionDelegate.onConnectionUpdate = { connection in
            switch connection {
            case .opened:
                self.retries = 0
                
            case .failed:
                self.reconnect(false)
            }
        }
        
        self.task = self.urlSession.webSocketTask(with: url)
    }
    
    static func stop() {
        self.task?.cancel(with: .goingAway, reason: nil)
    }
    
    static func reconnect(_ reset: Bool) {
        if reset {
            self.retries = 0
        }
        
        if self.retries >= self.retriesMax || self.task?.state == .running {
            return
        }
        self.retries += 1
        
        if self.task?.state == .running {
            self.stop()
        } else {
            self.task?.suspend()
        }
        
        if let request = self.task?.originalRequest {
            self.task = self.urlSession.webSocketTask(with: request)
        }
    }
}

extension TxListener {
    
    static func subscribe() {
        let request = Message.Outbound(method: "subscribe", parameters: [ "tm.event='Tx'" ])
        self.send(outbound: request)
    }
    
    static func unsubscribe() {
        let request = Message.Outbound(method: "unsubscribe_all", parameters: [ ])
        self.send(outbound: request)
    }
    
    private static func send(outbound: Message.Outbound) {
        guard let message = outbound.message else {
            return
        }
        
        self.task?.send(message, completionHandler: { error in
            if let error = error {
                Logger.log(.error(error))
            }
        })
    }
    
}

private extension TxListener {
    
    static func handleInbound(_ result: Result<URLSessionWebSocketTask.Message, Error>) {
        switch result {
        case .success(let message):
            defer {
                self.task?.receive(completionHandler: self.handleInbound(_:))
            }
            
            let inbound: Message.Inbound? = {
                switch message {
                case .data(let data):
                    return try? Message.Inbound.decode(from: data)
                    
                case .string(let string):
                    return try? Message.Inbound.decode(from: string)
                    
                @unknown default:
                    return nil
                }
            }()
            
            guard let inbound = inbound else {
                Logger.log(.error("Inbound malformed or unsupported"))
                return
            }
            
            inbound.result?.events.hash.forEach({
                self.resolve(txHash: $0)
            })
            
        case .failure(let error):
            Logger.log(.error(error))
        }
    }
    
}
