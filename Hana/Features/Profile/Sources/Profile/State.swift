//
//  State.swift
//
//
//  Created by Ivan Lisovyi on 21.12.20.
//

import ComposableArchitecture
import Kaori

import Login

@dynamicMemberLookup
public struct ProfileState: Equatable {
  public var profile: Profile?

  public var login: LoginState

  public var isLoggedIn: Bool {
    profile != nil
  }

  public init(
    profile: Profile? = nil,
    login: LoginState = LoginState()
  ) {
    self.profile = profile
    self.login = login
  }

  public subscript<T>(dynamicMember keyPath: KeyPath<LoginState, T>) -> T {
    login[keyPath: keyPath]
  }
}
