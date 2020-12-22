//
//  Reducer.swift
//  
//
//  Created by Ivan Lisovyi on 21.12.20.
//

import Foundation

import ComposableArchitecture

import Kaori
import Login

public let profileReducer =
  loginReducer
  .pullback(
    state: \.login,
    action: /ProfileAction.login,
    environment: {
      LoginEnvironment(apiClient: $0.apiClient, mainQueue: $0.mainQueue)
    }
  )
  .combined(with: Reducer<ProfileState, ProfileAction, ProfileEnvironment> {
    state, action, environment in
    switch action {
    case .logoutButtonTapped:
      return Effect(value: .logout)

    case .logout:
      state.profile = nil
      state.login = LoginState()
      return .none

    case let .login(.loginResponse(.success(profile))):
      state.profile = profile
      return .none

    case .login:
      return .none
    }
  }
)
