//
//  AppCore.swift
//  Hana
//
//  Created by Ivan Lisovyi on 28.12.20.
//

import Foundation
import CoreGraphics

import Combine
import ComposableArchitecture

import Posts
import Profile

import Kaori
import Common

struct AppState: Equatable {
  var selectedTab = 0

  private var _postsState = PostsState()

  var explore: PostsState {
    get {
      var state = _postsState
      state.userId = profile.userId
      return state
    }
    set {
      _postsState = newValue
      _postsState.userId = profile.userId
    }
  }
  var profile: ProfileState = ProfileState()

  public var savingState: SavingState {
    SavingState(
      layout: explore.layout,
      scale: explore.magnification.currentScale,
      selectedTab: selectedTab
    )
  }

  public var keychain: KeychainState {
    get { .init(credentials: .init(username: profile.username, password: profile.password)) }
    set {
      if let newCredentials = newValue.credentials {
        (profile.username, profile.password) = (newCredentials.username, newCredentials.password)
      }
    }
  }

  init(savedState: SavingState?) {
    guard let state = savedState else {
      self = AppState()
      return
    }

    self = .init(
      selectedTab: state.selectedTab,
      explore: PostsState(
        layout: state.layout,
        tags: nil,
        magnification: .init(currentScale: state.scale),
        pagination: .init()
      ),
      profile: .init()
    )
  }

  init(
    selectedTab: Int = 0,
    explore: PostsState = .init(),
    profile: ProfileState = .init()
  ) {
    self.selectedTab = selectedTab
    self.explore = explore
    self.profile = profile
  }
}

extension AppState {
  struct SavingState: Equatable, Codable {
    static let key = "com.ivanlisovyi.hana.saved.state"

    var layout: PostsState.Layout
    var scale: CGFloat
    var selectedTab: Int

    static func tryRestore() -> Self? {
      UserDefaults.standard.data(forKey: Self.key)
        .flatMap { try? JSONDecoder().decode(Self.self, from: $0) }
    }
  }
}

enum AppAction: Equatable {
  case launch
  case changeTab(Int)
  case explore(PostsAction)
  case profile(ProfileAction)
  case keychain(KeychainAction)
}

struct AppEnvironment {
  let apiClient: Kaori
  let keychain: Keychain
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let savingQueue: AnySchedulerOf<DispatchQueue>

  init(
    apiClient: Kaori = .live(),
    keychain: Keychain = .live(),
    mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler(),
    savingQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue(label: "com.ivanlisovyi.hana.state.saving").eraseToAnyScheduler()
  ) {
    self.apiClient = apiClient
    self.keychain = keychain
    self.mainQueue = mainQueue
    self.savingQueue = savingQueue
  }
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
  Posts.reducer.pullback(
    state: \.explore,
    action: /AppAction.explore,
    environment: {
      PostsEnvironment(
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

    case let .changeTab(selected):
      state.selectedTab = selected
      return .none

    case .explore:
      return .none

    case .profile(.login(.loginResponse(.success))):
      return Effect(value: .keychain(.save))

    case .profile(.logout):
      return Effect.merge(
        Effect(value: .keychain(.clear)),
        Effect(value: .explore(.pagination(.first)))
      )

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
.saving(AppState.SavingState.key, state: \.savingState) { key, environment in
  SavingEnvironment(
    save: { state in
      guard let data = try? JSONEncoder().encode(state) else {
        return
      }

      UserDefaults.standard.set(data, forKey: key)
    },
    queue: environment.savingQueue
  )
}
