//
//  HanaApp.swift
//  Hana
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import SwiftUI
import ComposableArchitecture

import Kaori
import KaoriLive

import Explore
import Login

struct AppState {
  var profile: Profile?

  var login: LoginState
  var posts: ExploreState
}

@main
struct HanaApp: App {
  var body: some Scene {
    WindowGroup {
      explore
    }
  }

  @ViewBuilder private var explore: some View {
    NavigationView {
      ExploreView(
        store: Store(
          initialState: ExploreState(login: LoginState()),
          reducer: exploreReducer,
          environment: ExploreEnvironment(
            apiClient: .live(),
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
          )
        )
      )
      .navigationBarHidden(true)
      .navigationViewStyle(StackNavigationViewStyle())
    }
  }
}
