//
//  PostsEnvironment.swift
//  Hana
//
//  Created by Ivan Lisovyi on 05.12.20.
//

import ComposableArchitecture

import Basics
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
  static let nextPageThreshold = 4

  public var posts: OrderedSet<Post>
  public var page: Int

  public var isFetching: Bool

  public var nextPage: Int {
    page + 1
  }

  public init(
    posts: [Post] = [],
    page: Int = 0,
    isFetching: Bool = false
  ) {
    self.posts = OrderedSet([])
    self.page = page
    self.isFetching = isFetching
  }
}

public enum PostsAction: Equatable {
  case fetch
  case fetchNext(after: Post)
  case fetchResponse(Result<[Post], Kaori.KaoriError>)
}

public let postsReducer = Reducer<PostsState, PostsAction, PostsEnvironment> {
  state, action, environment in
  switch action {
  case .fetch:
    if state.isFetching {
      return .none
    }

    state.isFetching = true

    return fetchPosts(
      page: state.nextPage,
      using: environment
    )

  case let .fetchNext(after: post):
    if state.isFetching {
      return .none
    }

    if let index = state.posts.firstIndex(of: post), index > state.posts.count - PostsState.nextPageThreshold {
      state.isFetching = true

      return fetchPosts(
        page: state.nextPage,
        using: environment
      )
    }
    return .none

  case let .fetchResponse(.success(posts)):
    state.posts.append(contentsOf: posts)
    state.page += 1
    state.isFetching = false

    return .none

  case .fetchResponse(.failure):
    state.isFetching = false

    return .none
  }
}

private func fetchPosts(page: Int, using environment: PostsEnvironment) -> Effect<PostsAction, Never> {
  return environment.apiClient
    .posts(page)
    .catchToEffect()
    .map(PostsAction.fetchResponse)
    .receive(on: environment.mainQueue)
    .eraseToEffect()
}
