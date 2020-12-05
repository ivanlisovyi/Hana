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
}

enum PostsAction: Equatable {
  case fetch
  case fetchResponse([Post])
}

let postsReducer = Reducer<PostsState, PostsAction, PostsEnvironment> {
  state, action, environment in
  switch action {
  case .fetch:
    return environment.danbooruClient
      .posts()
      .receive(on: environment.mainQueue)
      .replaceError(with: [])
      .map { PostsAction.fetchResponse($0) }
      .eraseToEffect()
  case let .fetchResponse(posts):
    state.posts = posts
    return .none
  }
}
