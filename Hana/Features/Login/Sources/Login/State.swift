//
//  State.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import ComposableArchitecture

public struct LoginState: Equatable {
  public var username: String
  public var password: String

  public var isLoggingIn: Bool

  public var alert: AlertState<LoginAction>?

  public var isFormValid: Bool {
    !username.isEmpty && !password.isEmpty
  }

  public init(
    username: String = "",
    password: String = "",
    isLoggingIn: Bool = false,
    alert: AlertState<LoginAction>? = nil
  ) {
    self.username = username
    self.password = password

    self.isLoggingIn = false
    self.alert = alert
  }
}
