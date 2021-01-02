//
//  PostReducer.swift
//  
//
//  Created by Ivan Lisovyi on 23.12.20.
//

import Foundation
import ComposableArchitecture

public let postReducer = Reducer<PostState, PostAction, PostEnvironment> {
  state, action, environment in
  switch action {
  case let .favorite(.favoriteResponse(.success(isFavorite))):
    state.favoritesCount += isFavorite ? 1 : -1
    return .none

  case .favorite, .onAppear:
    return .none
  }
}.favorite(
  state: \.favorite,
  action: /PostAction.favorite,
  environment: { FavoriteEnvironment(request: $0.favorite, mainQueue: $0.mainQueue) }
)
