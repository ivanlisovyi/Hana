//
//  FavoriteReducer.swift
//  
//
//  Created by Ivan Lisovyi on 23.12.20.
//

import Foundation
import ComposableArchitecture

/// A cancellation token that cancels in-flight favoriting requests.
public struct FavoriteCancelId<ID>: Hashable where ID: Hashable {
  var id: ID
}

public extension Reducer {
  func favorite<ID>(
    state: WritableKeyPath<State, FavoriteState<ID>>,
    action: CasePath<Action, FavoriteAction>,
    environment: @escaping (Environment) -> FavoriteEnvironment<ID>
  ) -> Reducer where ID: Hashable {
    .combine(
      self,
      Reducer<FavoriteState<ID>, FavoriteAction, FavoriteEnvironment> {
        state, action, environment in
        switch action {
        case .favoriteTapped:
          state.isFavorite.toggle()
          return environment.request(state.id, state.isFavorite)
            .receive(on: environment.mainQueue)
            .mapError { FavoriteError(underlayingError: $0 as NSError) }
            .catchToEffect()
            .map(FavoriteAction.favoriteResponse)
            .cancellable(id: FavoriteCancelId(id: state.id), cancelInFlight: true)

        case .favoriteResponse(.failure):
          state.isFavorite.toggle()
          return .none

        case let .favoriteResponse(.success(isFavorite)):
          state.isFavorite = isFavorite
          return .none
        }
      }
      .pullback(state: state, action: action, environment: environment)
    )
  }
}
