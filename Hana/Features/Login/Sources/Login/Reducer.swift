//
//  Reducer.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import Foundation
import Combine

import ComposableArchitecture
import Kaori

public let loginReducer = Reducer<LoginState, LoginAction, LoginEnvironment> {
  state, action, environment in
  switch action {
  case .loginButtonTapped:
    state.isLoggingIn = true

    return loginEffect(
      username: state.username,
      password: state.password,
      environment: environment
    )

  case let .loginResponse(.success(response)):
    state.isLoggingIn = false
    return .none

  case let .loginResponse(.failure(error)):
    state.alert = .init(title: .init(error.localizedDescription))
    state.isLoggingIn = false
    return Effect.fireAndForget(environment.apiClient.logout)

  case let .formUsernameChanged(username):
    state.username = username
    return .none

  case let .formPasswordChanged(password):
    state.password = password
    return .none

  case .alertDismissed:
    state.alert = nil
    return .none
  }
}

private func loginEffect(username: String, password: String, environment: LoginEnvironment) -> Effect<LoginAction, Never> {
  Effect<Void, Never>(
    value: environment.apiClient.login(.init(username: username, apiKey: password))
  )
  .flatMap(environment.apiClient.profile)
  .receive(on: environment.mainQueue)
  .catchToEffect()
  .map(LoginAction.loginResponse)
}
