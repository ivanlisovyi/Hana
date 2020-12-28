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
          initialState: .init(),
          reducer: appReducer,
          environment: AppEnvironment(
            apiClient: .live(),
            keychain: .live(),
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
          )
        )
      )
    }
  }
}
