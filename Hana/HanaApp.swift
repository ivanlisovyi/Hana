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
  @State var selected = 0

  var body: some Scene {
    WindowGroup {
      VStack(spacing: 0) {
        explore

        BottomBar(selectedIndex: $selected) {
          BottomBarItem(icon: "square.stack", text: "Explore", color: .darkPink)
          BottomBarItem(icon: "heart", text: "Favorites", color: .darkPink)
          BottomBarItem(icon: "person", text: "Profile", color: .darkPink)
        }
      }
      .frame(maxWidth: .infinity)
    }
  }

  private var explore: some View {
    StackNavigationView {
      ExploreView(
        store: Store(
          initialState: .init(),
          reducer: exploreReducer,
          environment: .init(
            apiClient: .live(),
            keychain: .live(),
            imagePreheater: .live(),
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
          )
        )
      )
      .navigationBarHidden(true)
    }
  }
}
