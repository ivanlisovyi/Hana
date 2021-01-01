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
  public var itemSize: Int
  public var tags: [Tag]?

  public var magnification: MagnificationState
  public var pagination: PaginationState<PostState>

  public init(
    itemSize: Int = 300,
    tags: [Tag]? = nil,
    magnification: MagnificationState = .init(),
    pagination: PaginationState<PostState> = .init()
  ) {
    self.itemSize = itemSize
    self.tags = tags
    self.magnification = magnification
    self.pagination = pagination
  }
}
