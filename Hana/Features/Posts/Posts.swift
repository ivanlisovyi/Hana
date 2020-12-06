//
//  PostsEnvironment.swift
//  Hana
//
//  Created by Ivan Lisovyi on 05.12.20.
//

import ComposableArchitecture
import Kaori

struct PostsEnvironment {
  var danbooruClient: Kaori
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

struct PostsState: Equatable {
  var posts: [Post]
  var page: Int

  var isFetching: Bool
}

enum PostsAction: Equatable {
  case fetch(after: Post? = nil)
  case fetchResponse([Post])
}

let postsReducer = Reducer<PostsState, PostsAction, PostsEnvironment> {
  state, action, environment in
  switch action {
  case let .fetch(post):
    if state.isFetching {
      return .none
    }

    if let post = post, let index = state.posts.firstIndex(of: post), index > state.posts.count - 10 {
      state.isFetching = true

      return environment.danbooruClient
        .posts(state.page + 1)
        .receive(on: environment.mainQueue)
        .replaceError(with: [])
        .map { PostsAction.fetchResponse($0) }
        .eraseToEffect()
    } else if post == nil {
      state.isFetching = true

      return environment.danbooruClient
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
