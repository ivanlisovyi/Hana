//
//  Profile.swift
//  
//
//  Created by Ivan Lisovyi on 05.12.20.
//

import Foundation

public struct Profile: Decodable {
  let id: Int

  let name: String
  let level: Int

  let createdAt: Date
  let updatedAt: Date

  let favoriteTags: String
  let blacklistedTags: String

  let favoriteCount: Int
  let favoriteLimit: Int
}
