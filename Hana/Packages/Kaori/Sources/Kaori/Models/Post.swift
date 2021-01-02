//
//  Post.swift
//  
//
//  Created by Lisovyi, Ivan on 04.12.20.
//

import Foundation
import Amber

public struct Post: Decodable, Identifiable, Hashable, Comparable {
  public enum Rating: String, Decodable, Equatable, Hashable {
    case safe = "s"
    case explicit = "e"
    case questionable = "q"
  }

  public struct Image: Decodable, Equatable, Hashable {
    public let width: Int
    public let height: Int

    public let url: URL
    public let previewURL: URL
  }

  public struct File: Decodable, Equatable, Hashable {
    public let url: URL
    public let size: Int
    public let `extension`: String
    public let md5: String?
  }

  public struct Tags: Decodable, Equatable, Hashable {
    public var all: [String]
    public var meta: [String]
    public var artist: [String]
    public var general: [String]
    public var character: [String]
    public var copyright: [String]
  }

  public struct Flags: Decodable, Equatable, Hashable {
    public let isRatingLocked: Bool
    public let isNoteLocked: Bool
    public let isStatusLocked: Bool
    public let isPending: Bool
    public let isFlagged: Bool
    public let isDeleted: Bool
    public let isBanned: Bool
  }

  public struct Score: Decodable, Equatable, Hashable {
    public let total: Int
    public let up: Int
    public let down: Int
  }

  public let id: Int
  public let pixivId: Int?

  public let createdAt: Date
  public let updatedAt: Date

  public let rating: Rating
  public let favoritesCount: Int
  public let isFavorited: Bool

  public let source: String

  public let score: Score

  public let image: Image
  public let file: File

  public let tags: Tags
  public let flags: Flags

  public init(
    id: Int,
    pixivId: Int? = nil,
    createdAt: Date,
    updatedAt: Date,
    rating: Rating,
    favoritesCount: Int,
    isFavorited: Bool,
    source: String,
    score: Score,
    image: Image,
    file: File,
    tags: Tags,
    flags: Flags
  ) {
    self.id = id
    self.pixivId = pixivId
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.rating = rating
    self.favoritesCount = favoritesCount
    self.isFavorited = isFavorited
    self.source = source
    self.score = score
    self.image = image
    self.file = file
    self.tags = tags
    self.flags = flags
  }

  public static func < (lhs: Post, rhs: Post) -> Bool {
    lhs.id < rhs.id
  }
}

public extension Post {
  var isNSFW: Bool {
    rating != .safe
  }

  var isLandscape: Bool {
    image.width > image.height
  }
}

extension Post {
  public init(from decoder: Decoder) throws {
    id = try decoder.decode("id")
    pixivId = try decoder.decodeIfPresent("pixivId")

    createdAt = try decoder.decode("createdAt")
    updatedAt = try decoder.decode("updatedAt")

    rating = try decoder.decode("rating")
    favoritesCount = try decoder.decode("favCount")
    isFavorited = try decoder.decode("isFavorited")

    source = try decoder.decode("source")

    score = Score(
      total: try decoder.decode("score"),
      up: try decoder.decode("upScore"),
      down: try decoder.decode("downScore")
    )

    image = Image(
      width: try decoder.decode("imageWidth"),
      height: try decoder.decode("imageHeight"),
      url: try decoder.decode("largeFileUrl"),
      previewURL: try decoder.decode("previewFileUrl")
    )

    file = File(
      url: try decoder.decode("fileUrl"),
      size: try decoder.decode("fileSize"),
      extension: try decoder.decode("fileExt"),
      md5: try decoder.decode("md5")
    )

    let tagsTransformer = TagsTransformer()

    tags = Tags(
      all: try decoder.decode("tagString", using: tagsTransformer.transform),
      meta: try decoder.decode("tagStringMeta", using: tagsTransformer.transform),
      artist: try decoder.decode("tagStringArtist", using: tagsTransformer.transform),
      general: try decoder.decode("tagStringGeneral", using: tagsTransformer.transform),
      character: try decoder.decode("tagStringCharacter", using: tagsTransformer.transform),
      copyright: try decoder.decode("tagStringCopyright", using: tagsTransformer.transform)
    )
    flags = try Flags(from: decoder)
  }
}

extension Post {
  public static var mock: Self {
    guard let post = try? KaoriMocks.decode([Post].self, from: "posts.json", in: .module).first else {
      fatalError("Unable to create \(Self.self) mock.")
    }

    return post
  }
}
