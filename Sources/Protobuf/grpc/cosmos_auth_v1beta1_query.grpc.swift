//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: cosmos/auth/v1beta1/query.proto
//

//
// Copyright 2018, gRPC Authors All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import GRPC
import NIO
import SwiftProtobuf


/// Query defines the gRPC querier service.
///
/// Usage: instantiate `Cosmos_Auth_V1beta1_QueryClient`, then call methods of this protocol to make API calls.
internal protocol Cosmos_Auth_V1beta1_QueryClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Cosmos_Auth_V1beta1_QueryClientInterceptorFactoryProtocol? { get }

  func accounts(
    _ request: Cosmos_Auth_V1beta1_QueryAccountsRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Cosmos_Auth_V1beta1_QueryAccountsRequest, Cosmos_Auth_V1beta1_QueryAccountsResponse>

  func account(
    _ request: Cosmos_Auth_V1beta1_QueryAccountRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Cosmos_Auth_V1beta1_QueryAccountRequest, Cosmos_Auth_V1beta1_QueryAccountResponse>

  func params(
    _ request: Cosmos_Auth_V1beta1_QueryParamsRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Cosmos_Auth_V1beta1_QueryParamsRequest, Cosmos_Auth_V1beta1_QueryParamsResponse>
}

extension Cosmos_Auth_V1beta1_QueryClientProtocol {
  internal var serviceName: String {
    return "cosmos.auth.v1beta1.Query"
  }

  /// Accounts returns all the existing accounts
  ///
  /// - Parameters:
  ///   - request: Request to send to Accounts.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func accounts(
    _ request: Cosmos_Auth_V1beta1_QueryAccountsRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Cosmos_Auth_V1beta1_QueryAccountsRequest, Cosmos_Auth_V1beta1_QueryAccountsResponse> {
    return self.makeUnaryCall(
      path: "/cosmos.auth.v1beta1.Query/Accounts",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeAccountsInterceptors() ?? []
    )
  }

  /// Account returns account details based on address.
  ///
  /// - Parameters:
  ///   - request: Request to send to Account.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func account(
    _ request: Cosmos_Auth_V1beta1_QueryAccountRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Cosmos_Auth_V1beta1_QueryAccountRequest, Cosmos_Auth_V1beta1_QueryAccountResponse> {
    return self.makeUnaryCall(
      path: "/cosmos.auth.v1beta1.Query/Account",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeAccountInterceptors() ?? []
    )
  }

  /// Params queries all parameters.
  ///
  /// - Parameters:
  ///   - request: Request to send to Params.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func params(
    _ request: Cosmos_Auth_V1beta1_QueryParamsRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Cosmos_Auth_V1beta1_QueryParamsRequest, Cosmos_Auth_V1beta1_QueryParamsResponse> {
    return self.makeUnaryCall(
      path: "/cosmos.auth.v1beta1.Query/Params",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeParamsInterceptors() ?? []
    )
  }
}

internal protocol Cosmos_Auth_V1beta1_QueryClientInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when invoking 'accounts'.
  func makeAccountsInterceptors() -> [ClientInterceptor<Cosmos_Auth_V1beta1_QueryAccountsRequest, Cosmos_Auth_V1beta1_QueryAccountsResponse>]

  /// - Returns: Interceptors to use when invoking 'account'.
  func makeAccountInterceptors() -> [ClientInterceptor<Cosmos_Auth_V1beta1_QueryAccountRequest, Cosmos_Auth_V1beta1_QueryAccountResponse>]

  /// - Returns: Interceptors to use when invoking 'params'.
  func makeParamsInterceptors() -> [ClientInterceptor<Cosmos_Auth_V1beta1_QueryParamsRequest, Cosmos_Auth_V1beta1_QueryParamsResponse>]
}

internal final class Cosmos_Auth_V1beta1_QueryClient: Cosmos_Auth_V1beta1_QueryClientProtocol {
  internal let channel: GRPCChannel
  internal var defaultCallOptions: CallOptions
  internal var interceptors: Cosmos_Auth_V1beta1_QueryClientInterceptorFactoryProtocol?

  /// Creates a client for the cosmos.auth.v1beta1.Query service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  internal init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Cosmos_Auth_V1beta1_QueryClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

/// Query defines the gRPC querier service.
///
/// To build a server, implement a class that conforms to this protocol.
internal protocol Cosmos_Auth_V1beta1_QueryProvider: CallHandlerProvider {
  var interceptors: Cosmos_Auth_V1beta1_QueryServerInterceptorFactoryProtocol? { get }

  /// Accounts returns all the existing accounts
  func accounts(request: Cosmos_Auth_V1beta1_QueryAccountsRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Cosmos_Auth_V1beta1_QueryAccountsResponse>

  /// Account returns account details based on address.
  func account(request: Cosmos_Auth_V1beta1_QueryAccountRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Cosmos_Auth_V1beta1_QueryAccountResponse>

  /// Params queries all parameters.
  func params(request: Cosmos_Auth_V1beta1_QueryParamsRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Cosmos_Auth_V1beta1_QueryParamsResponse>
}

extension Cosmos_Auth_V1beta1_QueryProvider {
  internal var serviceName: Substring { return "cosmos.auth.v1beta1.Query" }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  internal func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "Accounts":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Cosmos_Auth_V1beta1_QueryAccountsRequest>(),
        responseSerializer: ProtobufSerializer<Cosmos_Auth_V1beta1_QueryAccountsResponse>(),
        interceptors: self.interceptors?.makeAccountsInterceptors() ?? [],
        userFunction: self.accounts(request:context:)
      )

    case "Account":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Cosmos_Auth_V1beta1_QueryAccountRequest>(),
        responseSerializer: ProtobufSerializer<Cosmos_Auth_V1beta1_QueryAccountResponse>(),
        interceptors: self.interceptors?.makeAccountInterceptors() ?? [],
        userFunction: self.account(request:context:)
      )

    case "Params":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Cosmos_Auth_V1beta1_QueryParamsRequest>(),
        responseSerializer: ProtobufSerializer<Cosmos_Auth_V1beta1_QueryParamsResponse>(),
        interceptors: self.interceptors?.makeParamsInterceptors() ?? [],
        userFunction: self.params(request:context:)
      )

    default:
      return nil
    }
  }
}

internal protocol Cosmos_Auth_V1beta1_QueryServerInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when handling 'accounts'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeAccountsInterceptors() -> [ServerInterceptor<Cosmos_Auth_V1beta1_QueryAccountsRequest, Cosmos_Auth_V1beta1_QueryAccountsResponse>]

  /// - Returns: Interceptors to use when handling 'account'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeAccountInterceptors() -> [ServerInterceptor<Cosmos_Auth_V1beta1_QueryAccountRequest, Cosmos_Auth_V1beta1_QueryAccountResponse>]

  /// - Returns: Interceptors to use when handling 'params'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeParamsInterceptors() -> [ServerInterceptor<Cosmos_Auth_V1beta1_QueryParamsRequest, Cosmos_Auth_V1beta1_QueryParamsResponse>]
}
