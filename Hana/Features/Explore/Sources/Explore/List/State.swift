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
  static let nextPageThreshold = 4

  public var posts: OrderedSet<Post>
  public var page: Int

  public var isFetching: Bool
  public var isSheetPresented: Bool

  public var nextPage: Int {
    page + 1
  }

  public var profile: ProfileState

  public init(
    posts: [Post] = [],
    page: Int = 0,
    isFetching: Bool = false,
    isSheetPresented: Bool = false,
    profile: ProfileState = .init()
  ) {
    self.posts = OrderedSet([])
    self.page = page
    self.isFetching = isFetching
    self.isSheetPresented = isSheetPresented
    self.profile = profile
  }
}
