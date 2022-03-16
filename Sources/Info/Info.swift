//
//  Imversed+Info.swift
//  _NIODataStructures
//
//  Created by Ilya S. on 03.12.2021.
//

import Foundation
import GRPC

struct Info {
    static var connection: ClientConnection?
    
    private static let callOptions = CallOptions(logger: Logger.grpcLogger(label: "Info"))
}

extension Info {
    
    struct Node {
        let network: String
        
        init(nodeInfo: Tendermint_P2p_NodeInfo) {
            self.network = nodeInfo.network
        }
    }
    
    static func queryNode(completion: @escaping (Result<Node, Error>) -> Void) {
        guard let connection = self.connection else {
            completion(.failure(Imversed.Error.notConfigured))
            return
        }
        
        let client = Cosmos_Base_Tendermint_V1beta1_ServiceClient(
            channel: connection, defaultCallOptions: self.callOptions
        )
        let request = Cosmos_Base_Tendermint_V1beta1_GetNodeInfoRequest()
        client.getNodeInfo(request).response.whenComplete({ result in
            switch result {
            case .success(let response):
                let node = Node(nodeInfo: response.nodeInfo)
                
                Logger.log(.info("Node chain-id: \(node.network)"))
                completion(.success(node))
                
            case .failure(let error):
                Logger.log(.error(error))
                completion(.failure(error))
            }
        })
    }
    
}
