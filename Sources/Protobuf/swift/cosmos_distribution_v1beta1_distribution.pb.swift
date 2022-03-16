// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: cosmos/distribution/v1beta1/distribution.proto
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

/// Params defines the set of params for the distribution module.
struct Cosmos_Distribution_V1beta1_Params {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var communityTax: String = String()

  var baseProposerReward: String = String()

  var bonusProposerReward: String = String()

  var withdrawAddrEnabled: Bool = false

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// ValidatorHistoricalRewards represents historical rewards for a validator.
/// Height is implicit within the store key.
/// Cumulative reward ratio is the sum from the zeroeth period
/// until this period of rewards / tokens, per the spec.
/// The reference count indicates the number of objects
/// which might need to reference this historical entry at any point.
/// ReferenceCount =
///    number of outstanding delegations which ended the associated period (and
///    might need to read that record)
///  + number of slashes which ended the associated period (and might need to
///  read that record)
///  + one per validator for the zeroeth period, set on initialization
struct Cosmos_Distribution_V1beta1_ValidatorHistoricalRewards {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var cumulativeRewardRatio: [Cosmos_Base_V1beta1_DecCoin] = []

  var referenceCount: UInt32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// ValidatorCurrentRewards represents current rewards and current
/// period for a validator kept as a running counter and incremented
/// each block as long as the validator's tokens remain constant.
struct Cosmos_Distribution_V1beta1_ValidatorCurrentRewards {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var rewards: [Cosmos_Base_V1beta1_DecCoin] = []

  var period: UInt64 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// ValidatorAccumulatedCommission represents accumulated commission
/// for a validator kept as a running counter, can be withdrawn at any time.
struct Cosmos_Distribution_V1beta1_ValidatorAccumulatedCommission {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var commission: [Cosmos_Base_V1beta1_DecCoin] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// ValidatorOutstandingRewards represents outstanding (un-withdrawn) rewards
/// for a validator inexpensive to track, allows simple sanity checks.
struct Cosmos_Distribution_V1beta1_ValidatorOutstandingRewards {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var rewards: [Cosmos_Base_V1beta1_DecCoin] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// ValidatorSlashEvent represents a validator slash event.
/// Height is implicit within the store key.
/// This is needed to calculate appropriate amount of staking tokens
/// for delegations which are withdrawn after a slash has occurred.
struct Cosmos_Distribution_V1beta1_ValidatorSlashEvent {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var validatorPeriod: UInt64 = 0

  var fraction: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// ValidatorSlashEvents is a collection of ValidatorSlashEvent messages.
struct Cosmos_Distribution_V1beta1_ValidatorSlashEvents {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var validatorSlashEvents: [Cosmos_Distribution_V1beta1_ValidatorSlashEvent] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// FeePool is the global fee pool for distribution.
struct Cosmos_Distribution_V1beta1_FeePool {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var communityPool: [Cosmos_Base_V1beta1_DecCoin] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// CommunityPoolSpendProposal details a proposal for use of community funds,
/// together with how many coins are proposed to be spent, and to which
/// recipient account.
struct Cosmos_Distribution_V1beta1_CommunityPoolSpendProposal {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var title: String = String()

  var description_p: String = String()

  var recipient: String = String()

  var amount: [Cosmos_Base_V1beta1_Coin] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// DelegatorStartingInfo represents the starting info for a delegator reward
/// period. It tracks the previous validator period, the delegation's amount of
/// staking token, and the creation height (to check later on if any slashes have
/// occurred). NOTE: Even though validators are slashed to whole staking tokens,
/// the delegators within the validator may be left with less than a full token,
/// thus sdk.Dec is used.
struct Cosmos_Distribution_V1beta1_DelegatorStartingInfo {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var previousPeriod: UInt64 = 0

  var stake: String = String()

  var height: UInt64 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// DelegationDelegatorReward represents the properties
/// of a delegator's delegation reward.
struct Cosmos_Distribution_V1beta1_DelegationDelegatorReward {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var validatorAddress: String = String()

  var reward: [Cosmos_Base_V1beta1_DecCoin] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// CommunityPoolSpendProposalWithDeposit defines a CommunityPoolSpendProposal
/// with a deposit
struct Cosmos_Distribution_V1beta1_CommunityPoolSpendProposalWithDeposit {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var title: String = String()

  var description_p: String = String()

  var recipient: String = String()

  var amount: String = String()

  var deposit: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

#if swift(>=5.5) && canImport(_Concurrency)
extension Cosmos_Distribution_V1beta1_Params: @unchecked Sendable {}
extension Cosmos_Distribution_V1beta1_ValidatorHistoricalRewards: @unchecked Sendable {}
extension Cosmos_Distribution_V1beta1_ValidatorCurrentRewards: @unchecked Sendable {}
extension Cosmos_Distribution_V1beta1_ValidatorAccumulatedCommission: @unchecked Sendable {}
extension Cosmos_Distribution_V1beta1_ValidatorOutstandingRewards: @unchecked Sendable {}
extension Cosmos_Distribution_V1beta1_ValidatorSlashEvent: @unchecked Sendable {}
extension Cosmos_Distribution_V1beta1_ValidatorSlashEvents: @unchecked Sendable {}
extension Cosmos_Distribution_V1beta1_FeePool: @unchecked Sendable {}
extension Cosmos_Distribution_V1beta1_CommunityPoolSpendProposal: @unchecked Sendable {}
extension Cosmos_Distribution_V1beta1_DelegatorStartingInfo: @unchecked Sendable {}
extension Cosmos_Distribution_V1beta1_DelegationDelegatorReward: @unchecked Sendable {}
extension Cosmos_Distribution_V1beta1_CommunityPoolSpendProposalWithDeposit: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "cosmos.distribution.v1beta1"

extension Cosmos_Distribution_V1beta1_Params: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Params"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "community_tax"),
    2: .standard(proto: "base_proposer_reward"),
    3: .standard(proto: "bonus_proposer_reward"),
    4: .standard(proto: "withdraw_addr_enabled"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.communityTax) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.baseProposerReward) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.bonusProposerReward) }()
      case 4: try { try decoder.decodeSingularBoolField(value: &self.withdrawAddrEnabled) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.communityTax.isEmpty {
      try visitor.visitSingularStringField(value: self.communityTax, fieldNumber: 1)
    }
    if !self.baseProposerReward.isEmpty {
      try visitor.visitSingularStringField(value: self.baseProposerReward, fieldNumber: 2)
    }
    if !self.bonusProposerReward.isEmpty {
      try visitor.visitSingularStringField(value: self.bonusProposerReward, fieldNumber: 3)
    }
    if self.withdrawAddrEnabled != false {
      try visitor.visitSingularBoolField(value: self.withdrawAddrEnabled, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Distribution_V1beta1_Params, rhs: Cosmos_Distribution_V1beta1_Params) -> Bool {
    if lhs.communityTax != rhs.communityTax {return false}
    if lhs.baseProposerReward != rhs.baseProposerReward {return false}
    if lhs.bonusProposerReward != rhs.bonusProposerReward {return false}
    if lhs.withdrawAddrEnabled != rhs.withdrawAddrEnabled {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cosmos_Distribution_V1beta1_ValidatorHistoricalRewards: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ValidatorHistoricalRewards"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "cumulative_reward_ratio"),
    2: .standard(proto: "reference_count"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.cumulativeRewardRatio) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.referenceCount) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.cumulativeRewardRatio.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.cumulativeRewardRatio, fieldNumber: 1)
    }
    if self.referenceCount != 0 {
      try visitor.visitSingularUInt32Field(value: self.referenceCount, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Distribution_V1beta1_ValidatorHistoricalRewards, rhs: Cosmos_Distribution_V1beta1_ValidatorHistoricalRewards) -> Bool {
    if lhs.cumulativeRewardRatio != rhs.cumulativeRewardRatio {return false}
    if lhs.referenceCount != rhs.referenceCount {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cosmos_Distribution_V1beta1_ValidatorCurrentRewards: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ValidatorCurrentRewards"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "rewards"),
    2: .same(proto: "period"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.rewards) }()
      case 2: try { try decoder.decodeSingularUInt64Field(value: &self.period) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.rewards.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.rewards, fieldNumber: 1)
    }
    if self.period != 0 {
      try visitor.visitSingularUInt64Field(value: self.period, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Distribution_V1beta1_ValidatorCurrentRewards, rhs: Cosmos_Distribution_V1beta1_ValidatorCurrentRewards) -> Bool {
    if lhs.rewards != rhs.rewards {return false}
    if lhs.period != rhs.period {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cosmos_Distribution_V1beta1_ValidatorAccumulatedCommission: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ValidatorAccumulatedCommission"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "commission"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.commission) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.commission.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.commission, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Distribution_V1beta1_ValidatorAccumulatedCommission, rhs: Cosmos_Distribution_V1beta1_ValidatorAccumulatedCommission) -> Bool {
    if lhs.commission != rhs.commission {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cosmos_Distribution_V1beta1_ValidatorOutstandingRewards: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ValidatorOutstandingRewards"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "rewards"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.rewards) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.rewards.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.rewards, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Distribution_V1beta1_ValidatorOutstandingRewards, rhs: Cosmos_Distribution_V1beta1_ValidatorOutstandingRewards) -> Bool {
    if lhs.rewards != rhs.rewards {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cosmos_Distribution_V1beta1_ValidatorSlashEvent: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ValidatorSlashEvent"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "validator_period"),
    2: .same(proto: "fraction"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularUInt64Field(value: &self.validatorPeriod) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.fraction) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.validatorPeriod != 0 {
      try visitor.visitSingularUInt64Field(value: self.validatorPeriod, fieldNumber: 1)
    }
    if !self.fraction.isEmpty {
      try visitor.visitSingularStringField(value: self.fraction, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Distribution_V1beta1_ValidatorSlashEvent, rhs: Cosmos_Distribution_V1beta1_ValidatorSlashEvent) -> Bool {
    if lhs.validatorPeriod != rhs.validatorPeriod {return false}
    if lhs.fraction != rhs.fraction {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cosmos_Distribution_V1beta1_ValidatorSlashEvents: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ValidatorSlashEvents"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "validator_slash_events"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.validatorSlashEvents) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.validatorSlashEvents.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.validatorSlashEvents, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Distribution_V1beta1_ValidatorSlashEvents, rhs: Cosmos_Distribution_V1beta1_ValidatorSlashEvents) -> Bool {
    if lhs.validatorSlashEvents != rhs.validatorSlashEvents {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cosmos_Distribution_V1beta1_FeePool: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".FeePool"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "community_pool"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.communityPool) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.communityPool.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.communityPool, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Distribution_V1beta1_FeePool, rhs: Cosmos_Distribution_V1beta1_FeePool) -> Bool {
    if lhs.communityPool != rhs.communityPool {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cosmos_Distribution_V1beta1_CommunityPoolSpendProposal: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".CommunityPoolSpendProposal"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "title"),
    2: .same(proto: "description"),
    3: .same(proto: "recipient"),
    4: .same(proto: "amount"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.title) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.description_p) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.recipient) }()
      case 4: try { try decoder.decodeRepeatedMessageField(value: &self.amount) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.title.isEmpty {
      try visitor.visitSingularStringField(value: self.title, fieldNumber: 1)
    }
    if !self.description_p.isEmpty {
      try visitor.visitSingularStringField(value: self.description_p, fieldNumber: 2)
    }
    if !self.recipient.isEmpty {
      try visitor.visitSingularStringField(value: self.recipient, fieldNumber: 3)
    }
    if !self.amount.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.amount, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Distribution_V1beta1_CommunityPoolSpendProposal, rhs: Cosmos_Distribution_V1beta1_CommunityPoolSpendProposal) -> Bool {
    if lhs.title != rhs.title {return false}
    if lhs.description_p != rhs.description_p {return false}
    if lhs.recipient != rhs.recipient {return false}
    if lhs.amount != rhs.amount {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cosmos_Distribution_V1beta1_DelegatorStartingInfo: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".DelegatorStartingInfo"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "previous_period"),
    2: .same(proto: "stake"),
    3: .same(proto: "height"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularUInt64Field(value: &self.previousPeriod) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.stake) }()
      case 3: try { try decoder.decodeSingularUInt64Field(value: &self.height) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.previousPeriod != 0 {
      try visitor.visitSingularUInt64Field(value: self.previousPeriod, fieldNumber: 1)
    }
    if !self.stake.isEmpty {
      try visitor.visitSingularStringField(value: self.stake, fieldNumber: 2)
    }
    if self.height != 0 {
      try visitor.visitSingularUInt64Field(value: self.height, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Distribution_V1beta1_DelegatorStartingInfo, rhs: Cosmos_Distribution_V1beta1_DelegatorStartingInfo) -> Bool {
    if lhs.previousPeriod != rhs.previousPeriod {return false}
    if lhs.stake != rhs.stake {return false}
    if lhs.height != rhs.height {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cosmos_Distribution_V1beta1_DelegationDelegatorReward: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".DelegationDelegatorReward"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "validator_address"),
    2: .same(proto: "reward"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.validatorAddress) }()
      case 2: try { try decoder.decodeRepeatedMessageField(value: &self.reward) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.validatorAddress.isEmpty {
      try visitor.visitSingularStringField(value: self.validatorAddress, fieldNumber: 1)
    }
    if !self.reward.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.reward, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Distribution_V1beta1_DelegationDelegatorReward, rhs: Cosmos_Distribution_V1beta1_DelegationDelegatorReward) -> Bool {
    if lhs.validatorAddress != rhs.validatorAddress {return false}
    if lhs.reward != rhs.reward {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cosmos_Distribution_V1beta1_CommunityPoolSpendProposalWithDeposit: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".CommunityPoolSpendProposalWithDeposit"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "title"),
    2: .same(proto: "description"),
    3: .same(proto: "recipient"),
    4: .same(proto: "amount"),
    5: .same(proto: "deposit"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.title) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.description_p) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.recipient) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.amount) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.deposit) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.title.isEmpty {
      try visitor.visitSingularStringField(value: self.title, fieldNumber: 1)
    }
    if !self.description_p.isEmpty {
      try visitor.visitSingularStringField(value: self.description_p, fieldNumber: 2)
    }
    if !self.recipient.isEmpty {
      try visitor.visitSingularStringField(value: self.recipient, fieldNumber: 3)
    }
    if !self.amount.isEmpty {
      try visitor.visitSingularStringField(value: self.amount, fieldNumber: 4)
    }
    if !self.deposit.isEmpty {
      try visitor.visitSingularStringField(value: self.deposit, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Distribution_V1beta1_CommunityPoolSpendProposalWithDeposit, rhs: Cosmos_Distribution_V1beta1_CommunityPoolSpendProposalWithDeposit) -> Bool {
    if lhs.title != rhs.title {return false}
    if lhs.description_p != rhs.description_p {return false}
    if lhs.recipient != rhs.recipient {return false}
    if lhs.amount != rhs.amount {return false}
    if lhs.deposit != rhs.deposit {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
