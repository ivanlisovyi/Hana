//
//  AppView.swift
//  Hana
//
//  Created by Ivan Lisovyi on 28.12.20.
//

import SwiftUI
import Combine

import ComposableArchitecture

import UI

import Explore
import Profile
import Keychain

struct AppView: View {
  @Environment(\.colorScheme) var colorScheme

  let store: Store<AppState, AppAction>

  init(store: Store<AppState, AppAction>) {
    self.store = store
  }

  var body: some View {
    ZStack {
      if colorScheme == .dark {
        Color.primaryDark.ignoresSafeArea()
      } else {
        Color.primaryLight.ignoresSafeArea()
      }

      WithViewStore(store) { viewStore in
        VStack(spacing: 0) {
          GeometryReader { geometry in
            HStack(alignment: .center, spacing: geometry.safeAreaInsets.trailing) {
              Group {
                explore.id(0)
                profile.id(1)
              }
              .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .selection(
              width: geometry.size.width,
              spacing: geometry.safeAreaInsets.trailing,
              selection: viewStore.binding(get: \.selectedTab, send: AppAction.changeTab)
            )
          }

          Components.TabView(selectedIndex: viewStore.binding(get: \.selectedTab, send: AppAction.changeTab)) {
            TabItem { tabItem(systemName: "square.stack", isSelected: $0) }
            TabItem { tabItem(systemName: "person", isSelected: $0) }
          }.animation(.default)
        }
        .onAppear {
          viewStore.send(.launch)
        }
      }
    }
  }

  private func tabItem(systemName: String, isSelected: Bool) -> some View {
    Image(systemName: systemName)
      .imageScale(.large)
      .foregroundColor(isSelected ? .darkPink : .primary)
      .padding()
  }

  private var explore: some View {
    StackNavigationView {
      ExploreView(
        store: store.scope(state: { $0.explore }, action: AppAction.explore)
      )
      .navigationBarHidden(true)
    }
  }

  private var profile: some View {
    StackNavigationView {
      ProfileView(
        store: store.scope(state: { $0.profile }, action: AppAction.profile)
      )
    }
  }
}

#if DEBUG
struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(
      store: Store(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment(
          apiClient: .mock(),
          keychain: .mock(
            save: { _ in
              Just(())
                .setFailureType(to: KeychainError.self)
                .eraseToAnyPublisher()
            },
            retrieve: {
              Just(Keychain.Credentials(username: "test", password: "test"))
                .setFailureType(to: KeychainError.self)
                .eraseToAnyPublisher()
            }
          ),
          mainQueue: DispatchQueue.main.eraseToAnyScheduler()
        )
      )
    )
  }
}
#endif
