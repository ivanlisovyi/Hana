//
//  PostState.swift
//  
//
//  Created by Ivan Lisovyi on 23.12.20.
//

import Foundation
import CoreGraphics

import Kaori

@dynamicMemberLookup
public struct PostState: Identifiable, Hashable, Comparable {
  public let id: Int

  public var favorite: FavoriteState<ID> {
    get { .init(id: id, isFavorite: isFavorite) }
    set { isFavorite = newValue.isFavorite }
  }

  public let aspectRatio: CGFloat
  public let createdAt: String
  public let dimension: String

  var favoritesCount: Int
  private(set) var isFavorite: Bool

  private(set) var post: Post

  public init(post: Post) {
    self.id = post.id

    self.favoritesCount = post.favoritesCount
    self.isFavorite = post.isFavorited

    self.aspectRatio = CGFloat(post.image.width) / CGFloat(post.image.height)
    self.createdAt = Formatters.dateFormatter.string(from: post.createdAt)
    self.dimension = "\(post.image.width) x \(post.image.height)"

    self.post = post
  }

  public subscript<T>(dynamicMember keyPath: KeyPath<Post, T>) -> T {
    post[keyPath: keyPath]
  }

  public static func < (lhs: PostState, rhs: PostState) -> Bool {
    lhs.id < rhs.id
  }
}

enum Formatters {
  static var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    formatter.doesRelativeDateFormatting = true

    return formatter
  }()

  static let numberFormatter = NumberFormatter()
}
