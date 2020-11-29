//
//  HTTPHeader.swift
//  
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import Foundation

public typealias MIMEType = String
public typealias AccessToken = String

public enum HTTPHeader {
  case contentDisposition(String)
  case accept([MIMEType])
  case contentType(MIMEType)
  case authorization(AccessToken)
  case custom(String, String)

  public var key: String {
    switch self {
    case .contentDisposition:
      return "Content-Disposition"
    case .accept:
      return "Accept"
    case .contentType:
      return "Content-Type"
    case .authorization:
      return "Authorization"
    case .custom(let key, _):
      return key
    }
  }

  public var value: String {
    switch self {
    case .contentDisposition(let disposition):
      return disposition
    case .accept(let types):
      return types.joined(separator: ", ")
    case .contentType(let type):
      return type
    case .authorization(let token):
      return token
    case .custom(_, let value):
      return value
    }
  }
}

extension HTTPHeader: Equatable {}
