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

public let exploreReducer =
  loginReducer
  .optional()
  .pullback(
    state: \.login,
    action: /ExploreAction.login,
    environment: {
      LoginEnvironment(
        apiClient: $0.apiClient,
        mainQueue: $0.mainQueue
      )
    }
  ).combined(
    with: Reducer<ExploreState, ExploreAction, ExploreEnvironment> {
      state, action, environment in
      switch action {
      case .fetch:
        if state.isFetching {
          return .none
        }

        state.isFetching = true

        return fetchEffect(
          page: state.nextPage,
          using: environment
        )

      case let .fetchNext(after: post):
        if state.isFetching {
          return .none
        }

        if let index = state.posts.firstIndex(of: post), index > state.posts.count - ExploreState.nextPageThreshold {
          state.isFetching = true

          return fetchEffect(
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

      case .login:
        return .none
      }
    }
  )


private func fetchEffect(page: Int, using environment: ExploreEnvironment) -> Effect<ExploreAction, Never> {
  return environment.apiClient
    .posts(page)
    .catchToEffect()
    .map(ExploreAction.fetchResponse)
    .receive(on: environment.mainQueue)
    .eraseToEffect()
}
