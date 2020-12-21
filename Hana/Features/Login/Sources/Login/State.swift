//
//  State.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import ComposableArchitecture

import Kaori

public struct LoginState: Equatable {
  public var username: String
  public var password: String

  public var isLoggingIn: Bool

  public var profile: Profile?
  public var alert: AlertState<LoginAction>?

  public var isFormValid: Bool {
    !username.isEmpty && !password.isEmpty
  }

  public init(
    username: String = "",
    password: String = "",
    isLoggingIn: Bool = false,
    profile: Profile? = nil,
    alert: AlertState<LoginAction>? = nil
  ) {
    self.username = username
    self.password = password

    self.isLoggingIn = false

    self.profile = profile
    self.alert = alert
  }
}
