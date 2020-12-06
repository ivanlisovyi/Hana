//
//  HanaApp.swift
//  Hana
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import SwiftUI
import ComposableArchitecture

import KaoriLive
import Posts

@main
struct HanaApp: App {
  var body: some Scene {
    WindowGroup {
      PostsView(
        store: Store(
          initialState: PostsState(),
          reducer: postsReducer.debug(),
          environment: PostsEnvironment(
            apiClient: .live(),
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
          )
        )
      )
    }
  }
}
