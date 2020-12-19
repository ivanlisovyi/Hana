//
//  PostsEnvironment.swift
//  Hana
//
//  Created by Ivan Lisovyi on 19.12.20.
//

import ComposableArchitecture
import Kaori

public struct LoginState: Equatable {
  public var username: String
  public var password: String

  public var isLoggingIn: Bool

  public var alert: AlertState<LoginAction>?

  public var isFormValid: Bool {
    !username.isEmpty && !password.isEmpty
  }
}

public enum LoginAction: Equatable {
  case loginButtonTapped
  case loginResponse(Result<Profile, Kaori.KaoriError>)

  case formUsernameChanged(String)
  case formPasswordChanged(String)

  case alertDismissed
}

public struct LoginEnvironment {
  public let apiClient: Kaori
  public let mainQueue: AnySchedulerOf<DispatchQueue>

  public init(
    apiClient: Kaori,
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.apiClient = apiClient
    self.mainQueue = mainQueue
  }
}

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
