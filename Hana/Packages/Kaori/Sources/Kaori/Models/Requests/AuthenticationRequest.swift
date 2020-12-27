//
//  AuthenticationRequest.swift
//  
//
//  Created by Ivan Lisovyi on 06.12.20.
//

import Foundation

public struct AuthenticationRequest: Codable, Equatable {
  public let username: String
  public let apiKey: String

  public init(
    username: String,
    apiKey: String
  ) {
    self.username = username
    self.apiKey = apiKey
  }
}
