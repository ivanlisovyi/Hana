//
//  Saving.swift
//  
//
//  Created by Ivan Lisovyi on 31.12.20.
//

import Foundation
import ComposableArchitecture

public struct SavingEnvironment<State> where State: Equatable, State: Codable {
  public let queue: AnySchedulerOf<DispatchQueue>
  public let save: (State) -> Void

  public init(
    save: @escaping (State) -> Void,
    queue: AnySchedulerOf<DispatchQueue>
  ) {
    self.save = save
    self.queue = queue
  }
}

public extension Reducer {
  func saving<Key: Hashable, SavedState>(
    _ key: Key,
    state toSavingState: @escaping (State) -> SavedState,
    environment toSavingEnvironment: @escaping (Key, Environment) -> SavingEnvironment<SavedState>
  ) -> Reducer where SavedState: Equatable, SavedState: Codable {
    return Reducer { state, action, environment in
      let previousState = toSavingState(state)

      let effects = self.run(&state, action, environment)
      let nextState = toSavingState(state)

      guard previousState != nextState else { return effects }

      let savingEnvironment = toSavingEnvironment(key, environment)

      return .merge(
        Effect.fireAndForget {
          savingEnvironment.save(nextState)
        }
        .subscribe(on: savingEnvironment.queue)
        .eraseToEffect(),
        effects
      )
    }
  }
}
