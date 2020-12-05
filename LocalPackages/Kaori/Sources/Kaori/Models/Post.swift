//
//  Post.swift
//  
//
//  Created by Lisovyi, Ivan on 04.12.20.
//

import Foundation

public struct Post: Decodable {
  let id: Int
  let pixivId: Int?

  let createdAt: Date
  let updatedAt: Date

  let imageWidth: Int
  let imageHeight: Int

  let rating: String

  let score: Int
  let upScore: Int
  let downScore: Int

  let favCount: Int
  let isFavorited: Bool

  let source: String

  let fileSize: Int
  let fileExt: String
  let md5: String

  let tagString: String
  let tagStringGeneral: String
  let tagStringCharacter: String
  let tagStringCopyright: String
  let tagStringArtist: String
  let tagStringMeta: String

  let isRatingLocked: Bool
  let isNoteLocked: Bool
  let isStatusLocked: Bool
  let isPending: Bool
  let isFlagged: Bool
  let isDeleted: Bool
  let isBanned: Bool

  let fileUrl: URL
  let largeFileUrl: URL
  let previewFileUrl: URL

  let hasChildren: Bool
  let hasActiveChildren: Bool
}
