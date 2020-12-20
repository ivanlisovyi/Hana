//
//  Reducer.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import Foundation

import ComposableArchitecture
import Kaori

public let loginReducer = Reducer<LoginState, LoginAction, LoginEnvironment> {
  state, action, environment in
  switch action {
  case .loginButtonTapped:
    state.isLoggingIn = true
    return environment.apiClient
      .authenticate(
        Authentication(
          username: state.username,
          apiKey: state.password
        )
      )
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(LoginAction.loginResponse)

  case let .loginResponse(.success(response)):
    state.isLoggingIn = false
    return .none

  case let .loginResponse(.failure(error)):
    state.alert = .init(title: .init(error.localizedDescription))
    state.isLoggingIn = false
    return .none

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
