//
//  FavoriteView.swift
//  
//
//  Created by Ivan Lisovyi on 23.12.20.
//

import SwiftUI
import ComposableArchitecture

public struct FavoriteView<ID>: View where ID: Hashable {
  let store: Store<FavoriteState<ID>, FavoriteAction>

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      Button(action: { viewStore.send(.favoriteTapped) }) {
        Image(systemName: viewStore.isFavorite ? "heart.fill" : "heart")
          .font(.title)
          .foregroundColor(.red)
      }
    }
  }
}

#if DEBUG
struct FavoriteView_Previews: PreviewProvider {
  struct State: Equatable, Identifiable {
    let id: UUID
    var isFavorite: Bool

    var favorite: FavoriteState<ID> {
      get { .init(id: id, isFavorite: isFavorite) }
      set { isFavorite = newValue.isFavorite }
    }
  }

  enum Action: Equatable {
    case favorite(FavoriteAction)
  }

  struct Environment {
    var favorite: (State.ID, Bool) -> Effect<Bool, Error>
    var mainQueue: AnySchedulerOf<DispatchQueue>
  }

  static let reducer = Reducer<State, Action, Environment>.empty.favorite(
    state: \.favorite,
    action: /Action.favorite,
    environment: {
      FavoriteEnvironment(request: $0.favorite, mainQueue: $0.mainQueue)
    }
  )

  static var previews: some View {
    let store = Store(
      initialState: State(id: UUID(), isFavorite: false),
      reducer: reducer,
      environment: Environment(
        favorite: { id, isFavorite in
          Effect(value: isFavorite)
        },
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
      )
    )

    return WithViewStore(store) { viewStore in
      HStack {
        Text("Try it out!")

        FavoriteView(
          store: store.scope(state: { $0.favorite }, action: Action.favorite)
        )
      }
    }
  }
}
#endif
