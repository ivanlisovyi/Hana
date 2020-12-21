//
//  State.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import Foundation
import Common

import Login
import Kaori

public struct ExploreState: Equatable {
  static let nextPageThreshold = 4

  public var posts: OrderedSet<Post>
  public var page: Int

  public var isFetching: Bool
  public var isLoginSheetPresented: Bool

  public var nextPage: Int {
    page + 1
  }

  public var login: LoginState?

  public init(
    posts: [Post] = [],
    page: Int = 0,
    isFetching: Bool = false,
    isLoginSheetPresented: Bool = false,
    login: LoginState? = nil
  ) {
    self.posts = OrderedSet([])
    self.page = page
    self.isFetching = isFetching
    self.isLoginSheetPresented = isLoginSheetPresented
    self.login = login
  }
}
