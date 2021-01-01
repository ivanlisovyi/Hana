//
//  FavoriteView.swift
//  
//
//  Created by Ivan Lisovyi on 23.12.20.
//

import SwiftUI
import ComposableArchitecture
import Components

public struct FavoriteButton<ID>: View where ID: Hashable {
  let store: Store<FavoriteState<ID>, FavoriteAction>

  public var body: some View {
    WithViewStore(store) { viewStore in
      Button(action: { viewStore.send(.favoriteTapped) }) {
        Image(systemName: viewStore.isFavorite ? "heart.fill" : "heart")
          .font(.headline)
      }
    }
  }
}

public struct PlainFavoriteButtonStyle: ButtonStyle {
  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label.foregroundColor(
      configuration.isPressed ? Color.darkPink.opacity(0.7) : .darkPink
    )
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

    let view = WithViewStore(store) { viewStore in
      HStack {
        Text("Try it out!")

        FavoriteButton(
          store: store.scope(state: { $0.favorite }, action: Action.favorite)
        )
        .frame(width: 40, height: 40, alignment: .center)
      }
    }

    return Group {
      view
        .buttonStyle(ShapeBackgroundButtonStyle(shape: Circle()))
        .preferredColorScheme(.dark)
      view
        .buttonStyle(PlainFavoriteButtonStyle())
        .preferredColorScheme(.light)
    }
    .previewLayout(.fixed(width: 200, height: 100))
  }
}
#endif
