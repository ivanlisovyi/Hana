//
//  Reducer.swift
//  
//
//  Created by Ivan Lisovyi on 28.12.20.
//

import Foundation
import ComposableArchitecture

extension Reducer {
  public func pullback<GlobalState, GlobalAction, GlobalEnvironment>(
    state toLocalState: WritableKeyPath<GlobalState, State>,
    action toLocalAction: CasePath<GlobalAction, Action>,
    environment toLocalEnvironment: @escaping (GlobalState, GlobalEnvironment) -> Environment
  ) -> Reducer<GlobalState, GlobalAction, GlobalEnvironment> {
    .init { globalState, globalAction, globalEnvironment in
      guard let localAction = toLocalAction.extract(from: globalAction) else { return .none }

      return self.run(
        &globalState[keyPath: toLocalState],
        localAction,
        toLocalEnvironment(globalState, globalEnvironment)
      )
      .map(toLocalAction.embed)
    }
  }
}
