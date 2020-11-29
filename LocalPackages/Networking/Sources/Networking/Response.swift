//
//  Response.swift
//  
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import Foundation

@dynamicMemberLookup
public struct Response<Success> {
  public let value: Success
  public let response: HTTPURLResponse?

  public init(
    value: Success,
    response: HTTPURLResponse? = nil
  ) {
    self.value = value
    self.response = response
  }

  public subscript<T>(dynamicMember keyPath: KeyPath<HTTPURLResponse, T>) -> T? {
    response?[keyPath: keyPath]
  }
}
