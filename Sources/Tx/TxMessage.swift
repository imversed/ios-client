//
//  TxMessage.swift
//  Imversed
//
//  Created by Ilya S. on 29.12.2021.
//

import Foundation
import SwiftProtobuf

public class TxMessage: Encodable {
    typealias Content = SwiftProtobuf.Message
    
    var content: Content? { return nil }
}
