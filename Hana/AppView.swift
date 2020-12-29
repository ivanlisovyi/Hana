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
  private enum Tab: Int, Equatable {
    case explore
    case favorites
    case profile
  }

  @State private var selectedTab = Tab.explore

  private var selectedTabBinding: Binding<Int> {
    Binding(
      get: { selectedTab.rawValue },
      set: {
        if let tab = Tab(rawValue: $0) {
          selectedTab = tab
        }
      }
    )
  }

  let store: Store<AppState, AppAction>

  init(store: Store<AppState, AppAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        switch selectedTab {
        case .explore:
          explore
        case .favorites:
          favorites
        case .profile:
          profile
        }

        TabView(selectedIndex: selectedTabBinding) {
          TabItem { tabItem(systemName: "square.stack", isSelected: $0) }
          TabItem { tabItem(systemName: "heart", isSelected: $0) }
          TabItem { tabItem(systemName: "person", isSelected: $0) }
        }
      }
      .onAppear {
        viewStore.send(.launch)
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

  private var favorites: some View {
    StackNavigationView {
      EmptyView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
