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
import UI

import Keychain

@main
struct HanaApp: App {
  var body: some Scene {
    WindowGroup {
      explore
    }
  }

  private var explore: some View {
    StackNavigationView {
      ExploreView(
        store: Store(
          initialState: ExploreState(),
          reducer: exploreReducer,
          environment: ExploreEnvironment(
            apiClient: .live(),
            keychain: .live(),
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
          )
        )
      )
      .navigationBarHidden(true)
    }
  }
}
