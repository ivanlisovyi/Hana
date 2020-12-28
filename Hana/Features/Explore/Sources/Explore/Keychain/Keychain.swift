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

  public init(credentials: Keychain.Credentials? = nil) {
    self.credentials = credentials
  }
}

public enum KeychainAction: Equatable {
  case save
  case onSave(Result<Keychain.Credentials, KeychainError>)
  case restore
  case onRestore(Result<Keychain.Credentials, KeychainError>)
  case clear
}

public struct KeychainEnvironment {
  public var keychain: Keychain
  public var mainQueue: AnySchedulerOf<DispatchQueue>

  public init(
    keychain: Keychain,
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.keychain = keychain
    self.mainQueue = mainQueue
  }
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

          let credentials = Keychain.Credentials(username: username, password: password)

          return environment.keychain.save(credentials)
            .receive(on: environment.mainQueue)
            .map { _ in credentials }
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
