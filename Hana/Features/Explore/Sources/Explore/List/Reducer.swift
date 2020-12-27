//
//  Reducer.swift
//  Hana
//
//  Created by Ivan Lisovyi on 05.12.20.
//

import Combine
import ComposableArchitecture

import Common
import Kaori

import Login
import Profile

public let exploreReducer: Reducer<ExploreState, ExploreAction, ExploreEnvironment> = .combine(
  postReducer.forEach(
    state: \ExploreState.pagination.items,
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
    case let .setSheet(isPresented):
      state.isSheetPresented = isPresented
      return .none

    case .keychain(.onRestore(.success)):
      return Effect(value: .profile(.login(.loginButtonTapped)))

    case .keychain(.onRestore(.failure)),
         .keychain(.onSave(.success)):
      return Effect(value: .pagination(.first))

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

    case let .pagination(.response(.success(items))):
      return Effect.fireAndForget {
        let urls = items.map(\.image.url)
        environment.imagePreheater.start(urls)
      }

    case .pagination:
      return .none
    }
  }
  .pagination(
    state: \.pagination,
    action: /ExploreAction.pagination,
    environment: { env in
      PaginationEnvironment(
        fetch: { page, limit in
          env.apiClient.posts(.init(page: page, limit: limit))
            .map { $0.map(PostState.init(post:)) }
            .mapError(PaginationError.init(underlayingError:))
            .eraseToAnyPublisher()
        },
        mainQueue: env.mainQueue
      )
    }
  )
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
