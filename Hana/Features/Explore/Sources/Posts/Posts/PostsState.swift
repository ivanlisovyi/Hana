//
//  PostsState.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import Foundation
import CoreGraphics

import Common
import Kaori

import Post

public struct PostsState: Equatable {
  public struct Layout: Equatable, Codable {
    public var size: Int
    public var spacing: Int

    public init(
      size: Int = 300,
      spacing: Int = 10
    ) {
      self.size = size
      self.spacing = spacing
    }
  }

  public var layout: Layout
  public var tags: [Tag]?
  public var userId: Int?

  public var isRefreshing: Bool

  public var magnification: MagnificationState
  public var pagination: PaginationState<PostState>

  public var isFirstRefresh: Bool {
    isRefreshing && pagination.items.isEmpty
  }

  public init(
    layout: Layout = .init(),
    tags: [Tag]? = nil,
    userId: Int? = nil,
    isRefreshing: Bool = true,
    magnification: MagnificationState = .init(),
    pagination: PaginationState<PostState> = .init()
  ) {
    self.layout = layout
    self.tags = tags
    self.userId = userId
    self.isRefreshing = isRefreshing
    self.magnification = magnification
    self.pagination = pagination
  }
}
