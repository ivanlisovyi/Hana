//
//  HanaApp.swift
//  Hana
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import SwiftUI
import Combine
import ComposableArchitecture

import Kaori
import KaoriLive

import Explore
import Profile

import UI

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

@main
struct HanaApp: App {
  private enum Tab: Int, Equatable {
    case explore
    case favorites
    case profile
  }

  @State private var selectedTab = Tab.explore

  private var selectedTabBinding: Binding<Int> {
    Binding(
      get: { selectedTab.rawValue },
      set: {
        if let tab = Tab(rawValue: $0) {
          selectedTab = tab
        }
      }
    )
  }

  let store = Store<AppState, AppAction>(
    initialState: AppState(),
    reducer: appReducer,
    environment: AppEnvironment(
      apiClient: .live(),
      keychain: .live(),
      mainQueue: DispatchQueue.main.eraseToAnyScheduler()
    )
  )

  var body: some Scene {
    WindowGroup {
      WithViewStore(store) { viewStore in
        VStack(spacing: 0) {
          switch selectedTab {
          case .explore:
            explore
          case .favorites:
            favorites
          case .profile:
            profile
          }

          BottomBar(selectedIndex: selectedTabBinding) {
            BottomBarItem(icon: "square.stack", text: "Explore", color: .darkPink)
            BottomBarItem(icon: "heart", text: "Favorites", color: .darkPink)
            BottomBarItem(icon: "person", text: "Profile", color: .darkPink)
          }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
          viewStore.send(.launch)
        }
      }
    }
  }

  private var explore: some View {
    StackNavigationView {
      ExploreView(
        store: self.store.scope(state: { $0.explore }, action: AppAction.explore)
      )
      .navigationBarHidden(true)
    }
  }

  private var favorites: some View {
    StackNavigationView {
      VStack {
        EmptyView()
      }
      .frame(maxWidth: .infinity)
    }
  }

  private var profile: some View {
    StackNavigationView {
      ProfileView(
        store: self.store.scope(state: { $0.profile }, action: AppAction.profile)
      )
    }
  }
}
//
//keychain: .mock(
//  save: { _ in
//    Just(())
//      .setFailureType(to: KeychainError.self)
//      .eraseToAnyPublisher()
//  },
//  retrieve: {
//    Just(Keychain.Credentials(username: "test", password: "test"))
//      .setFailureType(to: KeychainError.self)
//      .eraseToAnyPublisher()
//  }
//),
