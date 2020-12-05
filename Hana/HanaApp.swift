//
//  HanaApp.swift
//  Hana
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import SwiftUI
import ComposableArchitecture
import Kaori

@main
struct HanaApp: App {
  var body: some Scene {
    WindowGroup {
      PostsView(
        store: Store(
          initialState: PostsState(posts: []),
          reducer: postsReducer,
          environment: PostsEnvironment(
            danbooruClient: Kaori.live,
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
          )
        )
      )
    }
  }
}
