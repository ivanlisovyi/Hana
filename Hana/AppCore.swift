//
//  AppCore.swift
//  Hana
//
//  Created by Ivan Lisovyi on 28.12.20.
//

import Foundation
import ComposableArchitecture

import Explore
import Profile

import Kaori
import Keychain

struct AppState: Equatable {
  var explore: ExploreState = ExploreState()
  var profile: ProfileState = ProfileState()

  public var keychain: KeychainState {
    get { .init(credentials: .init(username: profile.username, password: profile.password)) }
    set {
      if let newCredentials = newValue.credentials {
        (profile.username, profile.password) = (newCredentials.username, newCredentials.password)
      }
    }
  }
}

enum AppAction: Equatable {
  case launch
  case explore(ExploreAction)
  case profile(ProfileAction)
  case keychain(KeychainAction)
}

struct AppEnvironment {
  let apiClient: Kaori
  let keychain: Keychain
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
  profileReducer.pullback(
    state: \.profile,
    action: /AppAction.profile,
    environment: {
      ProfileEnvironment(
        apiClient: $0.apiClient,
        mainQueue: $0.mainQueue
      )
    }
  ),
  exploreReducer.pullback(
    state: \.explore,
    action: /AppAction.explore,
    environment: {
      ExploreEnvironment(
        apiClient: $0.apiClient,
        imagePreheater: .live(),
        mainQueue: $0.mainQueue
      )
    }
  ),
  Reducer { state, action, environment in
    switch action {
    case .launch:
      return Effect(value: .keychain(.restore))

    case .explore:
      return .none

    case .profile(.login(.loginResponse(.success))):
      return Effect(value: .keychain(.save))

    case .profile(.logout):
      return Effect(value: .keychain(.clear))

    case .profile:
      return .none

    case .keychain(.onRestore(.success)):
      return Effect(value: .profile(.login(.loginButtonTapped)))

    case .keychain(.onRestore(.failure)),
         .keychain(.onSave(.success)):
      return Effect(value: .explore(.pagination(.first)))

    case .keychain:
      return .none
    }
  }
).keychain(
  state: \.keychain,
  action: /AppAction.keychain,
  environment: {
    KeychainEnvironment(
      keychain: $0.keychain,
      mainQueue: $0.mainQueue
    )
  }
)
