//
//  HanaApp.swift
//  Hana
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import SwiftUI
import ComposableArchitecture
import KaoriLive

@main
struct HanaApp: App {
  var body: some Scene {
    WindowGroup {
      PostsView(
        store: Store(
          initialState: PostsState(posts: [], page: 1, isFetching: false),
          reducer: postsReducer.debug(),
          environment: PostsEnvironment(
            danbooruClient: .live(),
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
          )
        )
      )
    }
  }
}
