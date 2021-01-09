//
//  Reducer.swift
//  Hana
//
//  Created by Ivan Lisovyi on 05.12.20.
//

import CoreGraphics

import Combine
import ComposableArchitecture

import Common
import Kaori

import Post

struct ScaleThrottlingID: Hashable {}

private let postsReducer = Reducer<PostsState, PostsAction, PostsEnvironment> { state, action, environment in
  switch action {
  case let .sizeChanged(size):
    state.layout.size = size
    return .none

  case let .post(index, action):
    return Effect(value: .pagination(.next(after: index)))

  case let .magnification(.onChange(newValue)):
    let max = Swift.max(100, Float(state.layout.size) * Float(newValue))
    let min = Swift.min(max, 300)
    let newValue = Int(min)
    return Effect(value: .sizeChanged(newValue))
      .throttle(id: ScaleThrottlingID(), for: 0.1, scheduler: environment.mainQueue, latest: true)
      .eraseToEffect()

  case .magnification:
    return .none

  case .pagination(.first):
    state.isRefreshing = true
    return .none

  case let .pagination(.response(.success(items))):
    state.isRefreshing = false

    return Effect.fireAndForget {
      let urls = items.map(\.image.url)
      environment.imagePreheater.start(urls)
    }

  case .pagination:
    state.isRefreshing = false
    return .none
  }
}

public let reducer = Reducer<PostsState, PostsAction, PostsEnvironment>.combine(
  postReducer.forEach(
    state: \PostsState.pagination.items,
    action: /PostsAction.post(index:action:),
    environment: { env in
      PostEnvironment(
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
        return PaginationEnvironment<PostState>(
          fetch: { page, limit in
            postsEffect(page: page, limit: limit, tags: state.tags, using: env)
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

private func postsEffect(
  page: Int,
  limit: Int,
  tags: [Tag]? = nil,
  userId: Int? = nil,
  using environment: PostsEnvironment
) -> AnyPublisher<[PostState], PaginationError> {
  let posts = environment.apiClient.posts(.init(page: page, limit: limit, tags: tags))
  guard let userId = userId else {
    return posts.map { $0.map(PostState.init(post:)) }
      .mapError(PaginationError.init(underlayingError:))
      .eraseToAnyPublisher()
  }

  return posts.flatMap { result -> AnyPublisher<[Post], KaoriError> in
    let justPosts = Just(result)
      .setFailureType(to: KaoriError.self)
      .eraseToAnyPublisher()

    let ids = result.map(\.id)
    let statuses = environment.apiClient.favoriteStatus(.init(ids: ids, userId: userId))

    return Publishers.Zip(
      justPosts,
      statuses
    )
    .map(enrichFavoriteStatuses)
    .eraseToAnyPublisher()
  }
  .map { $0.map(PostState.init(post:)) }
  .mapError(PaginationError.init(underlayingError:))
  .eraseToAnyPublisher()
}

private func enrichFavoriteStatuses(for posts: [Post], statuses: [FavoriteStatus]) -> [Post] {
  posts.map { post -> Post in
    var newValue = post
    if statuses.contains(where: { $0.postId == post.id }) {
      newValue.isFavorited = true
    }
    return newValue
  }
}
