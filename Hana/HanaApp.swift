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
import Login

@main
struct HanaApp: App {
  var body: some Scene {
    WindowGroup {
      posts
    }
  }

  @ViewBuilder private var posts: some View {
    NavigationView {
      PostsView(
        store: Store(
          initialState: PostsState(login: LoginState()),
          reducer: postsReducer,
          environment: PostsEnvironment(
            apiClient: .live(),
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
          )
        )
      )
      .navigationBarHidden(true)
      .navigationViewStyle(StackNavigationViewStyle())
    }
  }

  @ViewBuilder private var settings: some View {
    Color.primary
      .colorInvert()
  }
}
