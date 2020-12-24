//
//  State.swift
//  
//
//  Created by Ivan Lisovyi on 24.12.20.
//

import Foundation
import ComposableArchitecture

import Keychain

public struct KeychainState: Equatable {
  public var credentials: Keychain.Credentials?
}

public enum KeychainAction {
  case save
  case onSave(Result<Void, KeychainError>)
  case restore
  case onRestore(Result<Keychain.Credentials, KeychainError>)
  case clear
}

public struct KeychainEnvironment {
  var keychain: Keychain
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

public extension Reducer {
  func keychain(
    state: WritableKeyPath<State, KeychainState>,
    action: CasePath<Action, KeychainAction>,
    environment: @escaping (Environment) -> KeychainEnvironment
  ) -> Reducer {
    .combine(
      self,
      Reducer<KeychainState, KeychainAction, KeychainEnvironment> {
        state, action, environment in
        switch action {
        case .save:
          guard let username = state.credentials?.username,
                let password = state.credentials?.password else {
            return .none
          }

          return environment.keychain.save(.init(username: username, password: password))
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(KeychainAction.onSave)

        case .onSave:
          return .none

        case .restore:
          return environment.keychain.retrieve()
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(KeychainAction.onRestore)

        case let .onRestore(.success(credentials)):
          state.credentials = credentials
          return .none

        case .onRestore(.failure):
          return .none

        case .clear:
          state.credentials = nil
          return environment.keychain.clear()
            .replaceError(with: ())
            .ignoreOutput()
            .map { _ -> Never in }
            .eraseToEffect()
            .fireAndForget()
        }
      }
      .pullback(state: state, action: action, environment: environment)
    )
  }
}
