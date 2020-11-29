//
//  Endpoint.swift
//  
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import Foundation

public typealias Credentials = URLCredential
public typealias Parameters = [String: Any]

public struct Endpoint {
  /// The endpoint path.
  let path: String

  /// The HTTP method for this endpoint.
  let httpMethod: HTTPMethod

  /// THe HTTP headers for this resource.
  let httpHeaders: [HTTPHeader]

  /// The request parameters.
  let parameters: Parameters?

  /// The credentials used in the authentication challenge.
  let credentials: Credentials?

  /// Creates a new `Endpoint` with given parameters.
  ///
  /// - Parameters:
  ///   - path: The endpoint path.
  ///   - httpMethod: The HTTP method for this endpoint. Defaults to `.get`.
  ///   - httpHeaders: The HTTP headers for this resource. Defaults to empty array.
  ///   - parameters: The request parameters. Defaults to `nil`.
  ///   - credentials: The credentials used in the authentication challenge. Defaults to `nil`.
  public init(
    path: String,
    httpMethod: HTTPMethod = .get,
    httpHeaders: [HTTPHeader] = [],
    parameters: Parameters? = nil,
    credentials: Credentials? = nil
  ) {
    self.path = path
    self.httpMethod = httpMethod
    self.httpHeaders = httpHeaders
    self.parameters = parameters
    self.credentials = credentials
  }
}

public extension Credentials {
  convenience init(user: String, password: String) {
    self.init(user: user, password: password, persistence: .forSession)
  }
}
