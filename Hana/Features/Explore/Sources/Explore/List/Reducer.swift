//
//  Reducer.swift
//  Hana
//
//  Created by Ivan Lisovyi on 05.12.20.
//

import ComposableArchitecture

import Common
import Kaori

import Login
import Profile

public let exploreReducer: Reducer<ExploreState, ExploreAction, ExploreEnvironment> = .combine(
  postReducer.forEach(
    state: \ExploreState.posts,
    action: /ExploreAction.post(index:action:),
    environment: { env in
      PostEnvironment(
        favorite: { id, isFavorite in
          favoriteEffect(id: id, isFavorite: isFavorite, using: env)
        },
        mainQueue: env.mainQueue
      )
    }
  ),
  profileReducer
    .pullback(
      state: \.profile,
      action: /ExploreAction.profile,
      environment: {
        ProfileEnvironment(
          apiClient: $0.apiClient,
          mainQueue: $0.mainQueue
        )
      }
    ),
  .init { state, action, environment in
    switch action {
    case .fetch:
      if state.isFetching {
        return .none
      }

      state.isFetching = true
      state.orderedPosts = OrderedSet()
      state.page = 0

      return fetchEffect(
        page: state.nextPage,
        using: environment
      )

    case let .fetchNext(after: post):
      if state.isFetching {
        return .none
      }

      if let index = state.posts.firstIndex(of: post),
         index > state.posts.count - ExploreState.nextPageThreshold {
        state.isFetching = true

        return fetchEffect(
          page: state.nextPage,
          using: environment
        )
      }
      return .none

    case let .fetchResponse(.success(posts)):
      state.orderedPosts.append(contentsOf: posts)
      state.page += 1
      state.isFetching = false

      return .none

    case .fetchResponse(.failure):
      state.isFetching = false

      return .none

    case let .setSheet(isPresented):
      state.isSheetPresented = isPresented
      return .none

    case .profile(.login(.loginResponse(.success))),
         .profile(.logout):
      return Effect(value: .fetch)

    case .profile:
      return .none

    case .post:
      return .none
    }
  }
)

private func fetchEffect(page: Int, using environment: ExploreEnvironment) -> Effect<ExploreAction, Never> {
  return environment.apiClient
    .posts(page)
    .map { posts in posts.map(PostState.init) }
    .catchToEffect()
    .map(ExploreAction.fetchResponse)
    .receive(on: environment.mainQueue)
    .eraseToEffect()
}

private func favoriteEffect(id: Int, isFavorite: Bool, using environment: ExploreEnvironment) -> Effect<Bool, Error> {
  if isFavorite {
    return environment.apiClient.favorite(id)
      .map { _ in true }
      .receive(on: environment.mainQueue)
      .mapError { $0 as Error }
      .eraseToEffect()
  }

  return environment.apiClient.unfavorite(id)
    .map { _ in false }
    .receive(on: environment.mainQueue)
    .mapError { $0 as Error }
    .eraseToEffect()
}
