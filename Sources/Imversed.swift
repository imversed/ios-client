//
//  Imversed.swift
//  Imversed
//
//  Created by Ilya S. on 03.12.2021.
//

import Foundation
import GRPC

public struct Imversed {
    
    public struct Connection {
        public typealias Socket = (host: String, port: Int)
        
        let imversed: Socket
        let tendermint: Socket
        
        public init(imversed: Socket, tendermint: Socket) {
            self.imversed = imversed
            self.tendermint = tendermint
        }
    }
    
    public struct Configuration {
        let timeout: Int64
        let retries: Int
        
        public static let `default` = Configuration(timeout: 120, retries: 5)
        
        public init(timeout: Int64, retries: Int) {
            self.timeout = timeout
            self.retries = retries
        }
    }
    
    public static func update(logLevel: LogLevel) {
        Logger.updateLog(level: logLevel)
    }
    
    public static func configure(connection: Connection, configuration: Configuration = .default) {
        Logger.log(.info("Starting on \(connection.imversed.host):\(connection.imversed.port)"))
        
        TxListener.start(host: connection.tendermint.host, port: connection.tendermint.port)
        
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        let connection = ClientConnection
            .insecure(group: group)
            .withConnectionBackoff(maximum: .seconds(configuration.timeout))
            .withConnectionBackoff(retries: configuration.retries >= 0 ? .upTo(configuration.retries) : .unlimited)
            .withConnectivityStateDelegate(Logger.ConnectivityStateHandler())
            .withErrorDelegate(Logger.ConnectivityErrorHandler())
            .connect(host: connection.imversed.host, port: connection.imversed.port)
        
        Info.connection = connection
        Auth.connection = connection
        Bank.connection = connection
        NFT.connection = connection
        Tx.connection = connection
        Complex.connection = connection
    }
    
    public static func reconnect() {
        TxListener.reconnect(true)
    }
    
    public static func update(gasConfiguration jsonString: String) {
        Utils.Estimate.updateConfiguration(with: jsonString)
    }
    
}
