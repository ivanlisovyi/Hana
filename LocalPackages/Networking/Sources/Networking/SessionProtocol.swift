//
//  SessionProtocol.swift
//  
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import Foundation
import Combine

/// Defines the minimum interface every concrete `SessionProtocol` implementation should support.
///
/// Every session is associated with a `Service` it works with and it will only accepts the requests
/// made against this target.
public protocol SessionProtocol {
  associatedtype Service: ServiceType

  /// Requests a `Decodable` instance for the given `Service`.
  ///
  /// - Parameter service: The `Service` for which the request shall be run.
  /// - Parameter type: The concrete `Decodable` type for the `Data` serialization.
  ///
  /// - Returns: A `Publisher` with `Response<Decodable>` or `Error`.
  func request<Value: Decodable>(
    _ service: Service,
    of type: Value.Type
  ) -> AnyPublisher<Response<Value>, Error>
}

extension SessionProtocol {
  func request<Value: Decodable>(
    _ service: Service,
    of type: Value.Type = Value.self
  ) -> AnyPublisher<Value, Error> {
    request(service, of: type)
      .map(\.value)
      .eraseToAnyPublisher()
  }
}
