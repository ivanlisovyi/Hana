//
//  State.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import Foundation
import CoreGraphics

import Common
import Kaori

public struct ExploreState: Equatable {
  public var currentScale: CGFloat
  public var lastScale: CGFloat
  public var itemSize: Int

  public var tags: [Tag]?

  public var pagination: PaginationState<PostState>

  public init(
    currentScale: CGFloat = 1.0,
    lastScale: CGFloat = 1.0,
    itemSize: Int = 150,
    tags: [Tag]? = nil,
    pagination: PaginationState<PostState> = .init()
  ) {
    self.currentScale = currentScale
    self.lastScale = lastScale
    self.itemSize = itemSize
    self.tags = tags
    self.pagination = pagination
  }
}
