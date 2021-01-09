//
//  Endpoints.swift
//  
//
//  Created by Lisovyi, Ivan on 01.12.20.
//

import Foundation

import Ning
import Kaori

// MARK: - Profile

public extension Endpoint {
  static func profile() -> Self {
    Endpoint(path: "/profile.json")
  }
}

// MARK: - Posts

public extension Endpoint {
  static func posts(request: PostsRequest) -> Self {
    var parameters: Parameters = [
      "page": request.page,
      "limit": request.limit
    ]

    parameters["tags"] = request.tags
    parameters["only"] = request.only

    return Endpoint(
      path: "/posts.json",
      parameters: parameters
    )
  }
}

// MARK: - Favorites

public extension Endpoint {
  static func favoriteStatus(request: FavoriteStatusRequest) -> Self {
    Endpoint(
      path: "favorites.json",
      httpMethod: .get,
      parameters: [
        "search[post_id]": request.ids,
        "search[user_id]": request.userId
      ]
    )
  }


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
