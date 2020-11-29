//
//  ServiceType.swift
//  
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import Foundation

/// Defines the minimum set of properties than describe any service.
public protocol ServiceType {
  /// The base URL for the `NetworkingSession`.
  var baseURL: URL { get }

  /// The endpoint that should be hit by a network request.
  var endpoint: Endpoint { get }
}

public extension URL {
  /// Creates an URL with the given static string meaning that this initializer won't accept interpolated strings.
  ///
  /// - Note: Raises `preconditionFailure` if it's impossible to create a valid `URL` with the given string.
  init(staticString string: StaticString) {
    guard let url = URL(string: "\(string)") else {
      preconditionFailure("Invalid static URL string: \(string)")
    }

    self = url
  }
}
