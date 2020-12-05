//
//  Post.swift
//  
//
//  Created by Lisovyi, Ivan on 04.12.20.
//

import Foundation

public struct Post: Decodable, Identifiable, Equatable {
  public let id: Int
  public let pixivId: Int?

  public let createdAt: Date
  public let updatedAt: Date

  public let imageWidth: Int
  public let imageHeight: Int

  public let rating: String

  public let score: Int
  public let upScore: Int
  public let downScore: Int

  public let favCount: Int
  public let isFavorited: Bool

  public let source: String

  public let fileSize: Int
  public let fileExt: String
  public let md5: String

  public let tagString: String
  public let tagStringGeneral: String
  public let tagStringCharacter: String
  public let tagStringCopyright: String
  public let tagStringArtist: String
  public let tagStringMeta: String

  public let isRatingLocked: Bool
  public let isNoteLocked: Bool
  public let isStatusLocked: Bool
  public let isPending: Bool
  public let isFlagged: Bool
  public let isDeleted: Bool
  public let isBanned: Bool

  public let fileUrl: URL
  public let largeFileUrl: URL
  public let previewFileUrl: URL

  public let hasChildren: Bool
  public let hasActiveChildren: Bool
}
