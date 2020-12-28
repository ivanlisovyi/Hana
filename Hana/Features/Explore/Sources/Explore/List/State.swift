//
//  State.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import Foundation
import Common

public struct ExploreState: Equatable {
  public var pagination: PaginationState<PostState>

  public init(pagination: PaginationState<PostState> = .init()) {
    self.pagination = pagination
  }
}
