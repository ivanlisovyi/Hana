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
    get { .init(id: id, isFavorite: post.isFavorited) }
    set { post = post.favorite(isFavorite: newValue.isFavorite) }
  }

  public var aspectRatio: CGFloat {
    CGFloat(post.image.width) / CGFloat(post.image.height)
  }

  var post: Post

  public init(post: Post) {
    self.id = post.id
    self.post = post
  }

  public subscript<T>(dynamicMember keyPath: KeyPath<Post, T>) -> T {
    post[keyPath: keyPath]
  }

  public static func < (lhs: PostState, rhs: PostState) -> Bool {
    lhs.id < rhs.id
  }
}

public extension Post {
  func favorite(isFavorite: Bool) -> Self {
    Post(
      id: id,
      pixivId: pixivId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      rating: rating,
      favoritesCount: favoritesCount,
      isFavorited: isFavorite,
      source: source,
      score: score,
      image: image,
      file: file,
      tags: tags,
      flags: flags
    )
  }
}
