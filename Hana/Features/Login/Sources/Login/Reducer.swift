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

    return Effect<Void, Never>(
      value: environment.apiClient.authenticate(.init(username: state.username, apiKey: state.password))
    )
    .flatMap(environment.apiClient.profile)
    .receive(on: environment.mainQueue)
    .print()
    .catchToEffect()
    .map(LoginAction.loginResponse)

  case let .loginResponse(.success(response)):
    state.isLoggingIn = false
    state.profile = response
    return .none

  case let .loginResponse(.failure(error)):
    state.alert = .init(title: .init(error.localizedDescription))
    state.isLoggingIn = false
    state.profile = nil
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
