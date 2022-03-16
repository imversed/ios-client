// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: cosmos/bank/v1beta1/bank.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

/// Params defines the parameters for the bank module.
struct Cosmos_Bank_V1beta1_Params {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var sendEnabled: [Cosmos_Bank_V1beta1_SendEnabled] = []

  var defaultSendEnabled: Bool = false

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// SendEnabled maps coin denom to a send_enabled status (whether a denom is
/// sendable).
struct Cosmos_Bank_V1beta1_SendEnabled {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var denom: String = String()

  var enabled: Bool = false

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// Input models transaction input.
struct Cosmos_Bank_V1beta1_Input {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var address: String = String()

  var coins: [Cosmos_Base_V1beta1_Coin] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// Output models transaction outputs.
struct Cosmos_Bank_V1beta1_Output {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var address: String = String()

  var coins: [Cosmos_Base_V1beta1_Coin] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// Supply represents a struct that passively keeps track of the total supply
/// amounts in the network.
/// This message is deprecated now that supply is indexed by denom.
struct Cosmos_Bank_V1beta1_Supply {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var total: [Cosmos_Base_V1beta1_Coin] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// DenomUnit represents a struct that describes a given
/// denomination unit of the basic token.
struct Cosmos_Bank_V1beta1_DenomUnit {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// denom represents the string name of the given denom unit (e.g uatom).
  var denom: String = String()

  /// exponent represents power of 10 exponent that one must
  /// raise the base_denom to in order to equal the given DenomUnit's denom
  /// 1 denom = 1^exponent base_denom
  /// (e.g. with a base_denom of uatom, one can create a DenomUnit of 'atom' with
  /// exponent = 6, thus: 1 atom = 10^6 uatom).
  var exponent: UInt32 = 0

  /// aliases is a list of string aliases for the given denom
  var aliases: [String] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// Metadata represents a struct that describes
/// a basic token.
struct Cosmos_Bank_V1beta1_Metadata {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var description_p: String = String()

  /// denom_units represents the list of DenomUnit's for a given coin
  var denomUnits: [Cosmos_Bank_V1beta1_DenomUnit] = []

  /// base represents the base denom (should be the DenomUnit with exponent = 0).
  var base: String = String()

  /// display indicates the suggested denom that should be
  /// displayed in clients.
  var display: String = String()

  /// name defines the name of the token (eg: Cosmos Atom)
  var name: String = String()

  /// symbol is the token symbol usually shown on exchanges (eg: ATOM). This can
  /// be the same as the display.
  var symbol: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

#if swift(>=5.5) && canImport(_Concurrency)
extension Cosmos_Bank_V1beta1_Params: @unchecked Sendable {}
extension Cosmos_Bank_V1beta1_SendEnabled: @unchecked Sendable {}
extension Cosmos_Bank_V1beta1_Input: @unchecked Sendable {}
extension Cosmos_Bank_V1beta1_Output: @unchecked Sendable {}
extension Cosmos_Bank_V1beta1_Supply: @unchecked Sendable {}
extension Cosmos_Bank_V1beta1_DenomUnit: @unchecked Sendable {}
extension Cosmos_Bank_V1beta1_Metadata: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "cosmos.bank.v1beta1"

extension Cosmos_Bank_V1beta1_Params: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Params"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "send_enabled"),
    2: .standard(proto: "default_send_enabled"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.sendEnabled) }()
      case 2: try { try decoder.decodeSingularBoolField(value: &self.defaultSendEnabled) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.sendEnabled.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.sendEnabled, fieldNumber: 1)
    }
    if self.defaultSendEnabled != false {
      try visitor.visitSingularBoolField(value: self.defaultSendEnabled, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Bank_V1beta1_Params, rhs: Cosmos_Bank_V1beta1_Params) -> Bool {
    if lhs.sendEnabled != rhs.sendEnabled {return false}
    if lhs.defaultSendEnabled != rhs.defaultSendEnabled {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cosmos_Bank_V1beta1_SendEnabled: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SendEnabled"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "denom"),
    2: .same(proto: "enabled"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.denom) }()
      case 2: try { try decoder.decodeSingularBoolField(value: &self.enabled) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.denom.isEmpty {
      try visitor.visitSingularStringField(value: self.denom, fieldNumber: 1)
    }
    if self.enabled != false {
      try visitor.visitSingularBoolField(value: self.enabled, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Bank_V1beta1_SendEnabled, rhs: Cosmos_Bank_V1beta1_SendEnabled) -> Bool {
    if lhs.denom != rhs.denom {return false}
    if lhs.enabled != rhs.enabled {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cosmos_Bank_V1beta1_Input: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Input"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "address"),
    2: .same(proto: "coins"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.address) }()
      case 2: try { try decoder.decodeRepeatedMessageField(value: &self.coins) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.address.isEmpty {
      try visitor.visitSingularStringField(value: self.address, fieldNumber: 1)
    }
    if !self.coins.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.coins, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Bank_V1beta1_Input, rhs: Cosmos_Bank_V1beta1_Input) -> Bool {
    if lhs.address != rhs.address {return false}
    if lhs.coins != rhs.coins {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cosmos_Bank_V1beta1_Output: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Output"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "address"),
    2: .same(proto: "coins"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.address) }()
      case 2: try { try decoder.decodeRepeatedMessageField(value: &self.coins) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.address.isEmpty {
      try visitor.visitSingularStringField(value: self.address, fieldNumber: 1)
    }
    if !self.coins.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.coins, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Bank_V1beta1_Output, rhs: Cosmos_Bank_V1beta1_Output) -> Bool {
    if lhs.address != rhs.address {return false}
    if lhs.coins != rhs.coins {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cosmos_Bank_V1beta1_Supply: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Supply"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "total"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.total) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.total.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.total, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Bank_V1beta1_Supply, rhs: Cosmos_Bank_V1beta1_Supply) -> Bool {
    if lhs.total != rhs.total {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cosmos_Bank_V1beta1_DenomUnit: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".DenomUnit"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "denom"),
    2: .same(proto: "exponent"),
    3: .same(proto: "aliases"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.denom) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.exponent) }()
      case 3: try { try decoder.decodeRepeatedStringField(value: &self.aliases) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.denom.isEmpty {
      try visitor.visitSingularStringField(value: self.denom, fieldNumber: 1)
    }
    if self.exponent != 0 {
      try visitor.visitSingularUInt32Field(value: self.exponent, fieldNumber: 2)
    }
    if !self.aliases.isEmpty {
      try visitor.visitRepeatedStringField(value: self.aliases, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Bank_V1beta1_DenomUnit, rhs: Cosmos_Bank_V1beta1_DenomUnit) -> Bool {
    if lhs.denom != rhs.denom {return false}
    if lhs.exponent != rhs.exponent {return false}
    if lhs.aliases != rhs.aliases {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cosmos_Bank_V1beta1_Metadata: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Metadata"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "description"),
    2: .standard(proto: "denom_units"),
    3: .same(proto: "base"),
    4: .same(proto: "display"),
    5: .same(proto: "name"),
    6: .same(proto: "symbol"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.description_p) }()
      case 2: try { try decoder.decodeRepeatedMessageField(value: &self.denomUnits) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.base) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.display) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.name) }()
      case 6: try { try decoder.decodeSingularStringField(value: &self.symbol) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.description_p.isEmpty {
      try visitor.visitSingularStringField(value: self.description_p, fieldNumber: 1)
    }
    if !self.denomUnits.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.denomUnits, fieldNumber: 2)
    }
    if !self.base.isEmpty {
      try visitor.visitSingularStringField(value: self.base, fieldNumber: 3)
    }
    if !self.display.isEmpty {
      try visitor.visitSingularStringField(value: self.display, fieldNumber: 4)
    }
    if !self.name.isEmpty {
      try visitor.visitSingularStringField(value: self.name, fieldNumber: 5)
    }
    if !self.symbol.isEmpty {
      try visitor.visitSingularStringField(value: self.symbol, fieldNumber: 6)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Bank_V1beta1_Metadata, rhs: Cosmos_Bank_V1beta1_Metadata) -> Bool {
    if lhs.description_p != rhs.description_p {return false}
    if lhs.denomUnits != rhs.denomUnits {return false}
    if lhs.base != rhs.base {return false}
    if lhs.display != rhs.display {return false}
    if lhs.name != rhs.name {return false}
    if lhs.symbol != rhs.symbol {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
