//
//  HanaApp.swift
//  Hana
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import SwiftUI
import Combine

import ComposableArchitecture

import KaoriLive
import Keychain

@main
struct HanaApp: App {
  var body: some Scene {
    WindowGroup {
      AppView(
        store: Store(
          initialState: AppState(
            savedState: .tryRestore()
          ),
          reducer: appReducer,
          environment: .init()
        )
      )
    }
  }
}
