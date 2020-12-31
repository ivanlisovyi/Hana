//
//  Magnification.swift
//  
//
//  Created by Ivan Lisovyi on 31.12.20.
//

import SwiftUI
import ComposableArchitecture

public struct MagnificationState: Equatable {
  public var currentScale: CGFloat
  public var lastScale: CGFloat

  public init(
    currentScale: CGFloat = 1.0,
    lastScale: CGFloat = 1.0
  ) {
    self.currentScale = currentScale
    self.lastScale = lastScale
  }
}

public enum MagnificationAction: Equatable {
  case onChange(CGFloat)
  case onEnded(CGFloat)
}

public struct MagnificationEnvironment {}

public extension Reducer {
  func magnification(
    state: WritableKeyPath<State, MagnificationState>,
    action: CasePath<Action, MagnificationAction>
  ) -> Reducer {
    .combine(
      Reducer<MagnificationState, MagnificationAction, MagnificationEnvironment> {
        state, action, environment in
        switch action {
        case let .onChange(scale):
          let delta = scale / state.lastScale
          if abs(state.lastScale - (state.currentScale * delta)) <= 0.1 {
            return .none
          }

          state.lastScale = scale
          state.currentScale = state.currentScale * delta

          return .none

        case .onEnded:
          state.lastScale = 1.0
          return .none
        }
      }.pullback(state: state, action: action, environment: { _ in  MagnificationEnvironment() }),
      self
    )
  }
}

extension MagnificationGesture {
  static func magnification(store: Store<MagnificationState, MagnificationAction>) -> some Gesture {
    let viewStore = ViewStore(store)

    return MagnificationGesture(minimumScaleDelta: 0.1)
      .onChanged {
        viewStore.send(.onChange($0))
      }
      .onEnded {
        viewStore.send(.onEnded($0))
      }
  }
}
