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
          initialState: ExploreState(),
          reducer: exploreReducer.debug(),
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
