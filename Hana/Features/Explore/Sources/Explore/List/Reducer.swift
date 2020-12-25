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
  Reducer<ExploreState, ExploreAction, ExploreEnvironment> { state, action, environment in
    switch action {
    case .onAppear:
      return Effect(value: .keychain(.restore))

    case .fetch:
      state.orderedPosts = OrderedSet()
      state.page = 0

      return fetchEffect(
        page: state.nextPage,
        using: environment
      )

    case let .fetchNext(after: post):
      if let index = state.posts.firstIndex(of: post),
         index > state.posts.count - ExploreState.nextPageThreshold {

        return fetchEffect(
          page: state.nextPage,
          using: environment
        )
      }
      return .none

    case let .fetchResponse(.success(posts)):
      state.orderedPosts.append(contentsOf: posts)
      state.page += 1
      return .none

    case .fetchResponse(.failure):
      return .none

    case let .setSheet(isPresented):
      state.isSheetPresented = isPresented

      return .none

    case .keychain(.onRestore(.success)):
      return Effect(value: .profile(.login(.loginButtonTapped)))

    case .keychain(.onRestore(.failure)):
      return Effect(value: .fetch)

    case .keychain(.onSave(.success)):
      return Effect(value: .fetch)

    case .keychain:
      return .none

    case .profile(.login(.loginResponse(.success))):
      return Effect(value: .keychain(.save))

    case .profile(.logout):
      return Effect(value: .keychain(.clear))

    case .profile:
      return .none

    case .post:
      return .none
    }
  }
  .keychain(
    state: \.keychain,
    action: /ExploreAction.keychain,
    environment: {
      KeychainEnvironment(
        keychain: $0.keychain,
        mainQueue: $0.mainQueue
      )
    }
  )
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
