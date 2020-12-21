//
//  Error.swift
//  
//
//  Created by Ivan Lisovyi on 21.12.20.
//

import Foundation

public enum KaoriError: LocalizedError, Equatable {
  case network(String)
  case decoding(String)
  case unknown

  public var errorDescription: String? {
    switch self {
    case let .network(description):
      return description
    case let .decoding(description):
      return description
    default:
      return "Unknown error occurred."
    }
  }
}
