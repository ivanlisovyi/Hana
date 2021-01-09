//
//  File.swift
//  
//
//  Created by Ivan Lisovyi on 09.01.21.
//

import Foundation

public struct FavoriteStatus: Codable, Equatable {
  public let id: Int
  public let postId: Int
  public let userId: Int

  public init(id: Int, postId: Int, userId: Int) {
    self.id = id
    self.postId = postId
    self.userId = userId
  }
}
