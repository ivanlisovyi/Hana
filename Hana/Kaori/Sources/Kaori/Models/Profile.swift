//
//  Profile.swift
//  
//
//  Created by Ivan Lisovyi on 05.12.20.
//

import Foundation

public struct Profile: Codable, Identifiable, Equatable {
  public let id: Int

  public let name: String
  public let level: Int

  public let createdAt: Date
  public let updatedAt: Date

  public let favoriteTags: String
  public let blacklistedTags: String

  public let favoriteCount: Int
  public let favoriteLimit: Int
}
