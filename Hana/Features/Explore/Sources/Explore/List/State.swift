//
//  State.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import Foundation
import Common

import Kaori

public struct ExploreState: Equatable {
  public var itemSize: Int

  public var tags: [Tag]?

  public var pagination: PaginationState<PostState>

  public init(
    itemSize: Int = 150,
    tags: [Tag]? = nil,
    pagination: PaginationState<PostState> = .init()
  ) {
    self.itemSize = itemSize
    self.tags = tags
    self.pagination = pagination
  }
}
