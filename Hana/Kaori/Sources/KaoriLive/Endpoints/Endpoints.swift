//
//  Endpoints.swift
//  
//
//  Created by Lisovyi, Ivan on 01.12.20.
//

import Foundation
import Ning

// MARK: - Profile

public extension Endpoint {
  static func profile() -> Self {
    Endpoint(path: "/profile.json")
  }
}

// MARK: - Posts

public extension Endpoint {
  static func posts(page: Int = 1, limit: Int = 20) -> Self {
    Endpoint(
      path: "/posts.json",
      parameters: [
        "page": page,
        "limit": limit
      ]
    )
  }
}

// MARK: - Favorites

public extension Endpoint {
  static func favorite(id: Int) -> Self {
    Endpoint(
      path: "favorites.json",
      httpMethod: .post,
      parameters: [
        "post_id": id
      ]
    )
  }

  static func unfavorite(id: Int) -> Self {
    Endpoint(
      path: "favorites/\(id).json",
      httpMethod: .delete
    )
  }
}
