//
//  TxListener+Message.swift
//  Imversed
//
//  Created by Ilya S. on 15.02.2022.
//

import Foundation

extension TxListener {
    struct Message { }
}

// MARK: - Outbound

extension TxListener.Message {
    
    struct Outbound: Encodable {
        enum CodingKeys: String, CodingKey {
            case id         = "id"
            case version    = "jsonrpc"
            case method     = "method"
            case parameters = "params"
        }
        
        let id: String
        let version: String
        let method: String
        let parameters: [String]
        
        var message: URLSessionWebSocketTask.Message? {
            guard let data = try? JSONEncoder().encode(self) else {
                return nil
            }
            return .data(data)
        }
        
        init(method: String, parameters: [String]) {
            self.id = "0"
            self.version = "2.0"
            self.method = method
            self.parameters = parameters
        }
    }
    
}

// MARK: - Inbound

extension TxListener.Message {
    
    struct Inbound: Decodable {
        struct Result: Decodable {
            struct Events: Decodable {
                enum CodingKeys: String, CodingKey {
                    case hash = "tx.hash"
                }
                
                let hash: [String]
            }
            
            enum CodingKeys: String, CodingKey {
                case query  = "query"
                case events = "events"
            }
            
            let query: String
            let events: Events
        }
        
        enum CodingKeys: String, CodingKey {
            case id         = "id"
            case version    = "jsonrpc"
            case result     = "result"
        }
        
        let id: String
        let version: String
        let result: Result?
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.id = try container.decode(String.self, forKey: .id)
            self.version = try container.decode(String.self, forKey: .version)
            
            let result = try container.nestedContainer(keyedBy: Result.CodingKeys.self, forKey: .result)
            if result.contains(.query) && result.contains(.events) {
                self.result = try container.decode(Result.self, forKey: .result)
            } else {
                self.result = nil
            }
        }
        
        static func decode(from inbound: String) throws -> Self {
            guard let data = inbound.data(using: .utf8) else {
                throw NSError(
                    domain: "TxListener+Message",
                    code: -1,
                    userInfo: [ NSLocalizedDescriptionKey: "Malformed inbound string" ]
                )
            }
            return try self.decode(from: data)
        }
        
        static func decode(from inobund: Data) throws -> Self {
            return try JSONDecoder().decode(Inbound.self, from: inobund)
        }
    }
    
}
