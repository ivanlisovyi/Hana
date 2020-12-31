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

private let postsReducer = Reducer<PostsState, PostsAction, PostsEnvironment> { state, action, environment in
  switch action {
  case let .itemSizeChanged(size):
    state.itemSize = size
    return .none
    
  case .post:
    return .none

  case let .magnification(.onChange(newValue)):
    let max = Swift.max(100, Float(state.itemSize) * Float(newValue))
    let min = Swift.min(max, 300)
    let newValue = Int(min)
    return Effect(value: .itemSizeChanged(newValue))
      .throttle(id: ScaleThrottlingID(), for: 0.1, scheduler: environment.mainQueue, latest: true)
      .eraseToEffect()

  case .magnification:
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

public let reducer = Reducer<PostsState, PostsAction, PostsEnvironment>.combine(
  postItemReducer.forEach(
    state: \PostsState.pagination.items,
    action: /PostsAction.post(index:action:),
    environment: { env in
      PostItemEnvironment(
        favorite: { id, isFavorite in
          favoriteEffect(id: id, isFavorite: isFavorite, using: env)
        },
        mainQueue: env.mainQueue
      )
    }
  ),
  postsReducer
    .pagination(
      state: \.pagination,
      action: /PostsAction.pagination,
      environment: { state, env in
        return PaginationEnvironment<PostItemState>(
          fetch: { page, limit in
            env.apiClient.posts(.init(page: page, limit: limit, tags: state.tags))
              .map { $0.map(PostItemState.init(post:)) }
              .mapError(PaginationError.init(underlayingError:))
              .eraseToAnyPublisher()
          },
          mainQueue: env.mainQueue
        )
      }
    )
    .magnification(
      state: \.magnification,
      action: /PostsAction.magnification
    )
)

private func favoriteEffect(id: Int, isFavorite: Bool, using environment: PostsEnvironment) -> Effect<Bool, Error> {
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
