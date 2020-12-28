//
//  State.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import Foundation
import Common

import Kaori
import Login
import Profile

public struct ExploreState: Equatable {
  public var isSheetPresented: Bool

  public var pagination: PaginationState<PostState>

  public init(
    isSheetPresented: Bool = false,
    pagination: PaginationState<PostState> = .init()
  ) {
    self.isSheetPresented = isSheetPresented
    self.pagination = pagination
  }
}
