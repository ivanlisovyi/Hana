//
//  Profile.swift
//  
//
//  Created by Ivan Lisovyi on 05.12.20.
//

import Foundation
import Amber

public struct Profile: Decodable, Identifiable, Equatable {
  public enum Level: Int, Decodable, Equatable {
    case anonymous = 0
    case member = 20
    case gold = 30
    case platinum = 31
    case builder = 32
    case moderator = 40
    case admin = 50
  }

  public struct Tags: Decodable, Equatable {
    public let favorite: [String]
    public let blacklisted: [String]
  }

  public let id: Int

  public let name: String
  public let level: Level

  public let createdAt: Date
  public let updatedAt: Date

  public let favoriteCount: Int
  public let favoriteLimit: Int

  public let tags: Tags
}

public extension Profile {
  init(from decoder: Decoder) throws {
    id = try decoder.decode("id")
    name = try decoder.decode("name")
    level = try decoder.decode("level")

    createdAt = try decoder.decode("createdAt")
    updatedAt = try decoder.decode("updatedAt")

    favoriteCount = try decoder.decode("favoriteCount")
    favoriteLimit = try decoder.decode("favoriteLimit")

    let transformer = TagsTransformer()

    tags = Tags(
      favorite: try decoder.decode("favoriteTags", using: transformer.transform),
      blacklisted: try decoder.decode("blacklistedTags", using: transformer.transform)
    )

  }
}
