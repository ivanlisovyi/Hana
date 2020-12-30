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

struct ScaleThrottlingID: Hashable {}

private let exploreReducer = Reducer<ExploreState, ExploreAction, ExploreEnvironment> { state, action, environment in
  switch action {
  case let .scale(.changed(scale)):
    let delta = scale / state.lastScale
    if abs(state.lastScale - (state.currentScale * delta)) <= 0.1 {
      return .none
    }

    state.lastScale = scale
    state.currentScale = state.currentScale * delta

    let max = Swift.max(100, Float(state.itemSize) * Float(scale))
    let min = Swift.min(max, 300)
    let newValue = Int(min)
    return Effect(value: .itemSizeChanged(newValue))
      .throttle(id: ScaleThrottlingID(), for: 0.2, scheduler: environment.mainQueue, latest: true)
      .eraseToEffect()

  case .scale(.ended):
    state.lastScale = 1.0
    return .none

  case let .itemSizeChanged(size):
    state.itemSize = size
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

public let reducer = Reducer<ExploreState, ExploreAction, ExploreEnvironment>.combine(
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
  exploreReducer
    .pagination(
      state: \.pagination,
      action: /ExploreAction.pagination,
      environment: { state, env in
        return PaginationEnvironment<PostState>(
          fetch: { page, limit in
            env.apiClient.posts(.init(page: page, limit: limit, tags: state.tags))
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
