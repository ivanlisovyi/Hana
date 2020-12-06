//
//  PostsEnvironment.swift
//  Hana
//
//  Created by Ivan Lisovyi on 05.12.20.
//

import ComposableArchitecture
import Kaori

public struct PostsEnvironment {
  public var apiClient: Kaori
  public var mainQueue: AnySchedulerOf<DispatchQueue>

  public init(
    apiClient: Kaori,
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.apiClient = apiClient
    self.mainQueue = mainQueue
  }
}

public struct PostsState: Equatable {
  public var posts: [Post]
  public var page: Int

  public var isFetching: Bool

  public init(
    posts: [Post] = [],
    page: Int = 0,
    isFetching: Bool = false
  ) {
    self.posts = posts
    self.page = page
    self.isFetching = isFetching
  }
}

public enum PostsAction: Equatable {
  case fetch(after: Post? = nil)
  case fetchResponse([Post])
}

public let postsReducer = Reducer<PostsState, PostsAction, PostsEnvironment> {
  state, action, environment in
  switch action {
  case let .fetch(post):
    if state.isFetching {
      return .none
    }

    if let post = post, let index = state.posts.firstIndex(of: post), index > state.posts.count - 10 {
      state.isFetching = true

      return environment.apiClient
        .posts(state.page + 1)
        .receive(on: environment.mainQueue)
        .replaceError(with: [])
        .map { PostsAction.fetchResponse($0) }
        .eraseToEffect()
    } else if post == nil {
      state.isFetching = true

      return environment.apiClient
        .posts(state.page + 1)
        .receive(on: environment.mainQueue)
        .replaceError(with: [])
        .map { PostsAction.fetchResponse($0) }
        .eraseToEffect()
    }

    return .none
  case let .fetchResponse(posts):
    state.posts.append(contentsOf: posts)
    state.page += 1
    state.isFetching = false

    return .none
  }
}
