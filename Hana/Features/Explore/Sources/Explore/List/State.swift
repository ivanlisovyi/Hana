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
  public var pagination: PaginationState<PostState>

  public var tags: [Tag]?

  public init(
    pagination: PaginationState<PostState> = .init(),
    tags: [Tag]? = nil
  ) {
    self.pagination = pagination
    self.tags = tags
  }
}
