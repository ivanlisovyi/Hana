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
  Reducer<ExploreState, ExploreAction, ExploreEnvironment> { state, action, environment in
    switch action {
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
