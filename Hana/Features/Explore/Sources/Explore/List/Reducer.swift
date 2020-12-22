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

public let exploreReducer = Reducer<ExploreState, ExploreAction, ExploreEnvironment>.combine(
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
      state.posts = OrderedSet()
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
      state.posts.append(contentsOf: posts)
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
