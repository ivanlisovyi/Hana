//
//  FavoriteStatusRequest.swift
//  
//
//  Created by Ivan Lisovyi on 09.01.21.
//

import Foundation

public struct FavoriteStatusRequest: Equatable, Codable {
  public let ids: [Int]
  public let userId: Int

  public init(ids: [Int], userId: Int) {
    self.ids = ids
    self.userId = userId
  }
}
