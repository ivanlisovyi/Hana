//
//  View.swift
//  Hana
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import SwiftUI
import Combine

import ComposableArchitecture

import Kaori
import Components
import Common

import Login
import Profile

public struct ExploreView: View {
  @Environment(\.colorScheme) var colorScheme

  private let store: Store<ExploreState, ExploreAction>

  private let columns = [
    GridItem(.adaptive(minimum: 300), alignment: .top)
  ]

  public init(store: Store<ExploreState, ExploreAction>) {
    self.store = store
  }

  public var body: some View {
    ZStack {
     (colorScheme == .dark ? Color.primaryDark : Color.primaryLight)
      .ignoresSafeArea()

      VStack(spacing: 0) {
        TopBar {
          leading
        }

        content
      }
    }
  }

  private var leading: some View {
    WithViewStore(self.store) { viewStore in
      Button(action: { viewStore.send(.pagination(.first)) }) {
        FlowerView()
          .frame(width: 30, height: 30, alignment: .center)
      }
    }
  }

  private var trailing: some View {
    WithViewStore(self.store) { viewStore in
      Button(action: { viewStore.send(.setSheet(isPresented: true)) }) {
        Image(systemName: "person")
          .font(.title)
          .foregroundColor(.darkPink)
      }
      .sheet(
        isPresented: viewStore.binding(
          get: { $0.isSheetPresented },
          send: ExploreAction.setSheet(isPresented:)
        )
      ) {
        StackNavigationView {
          ProfileView(store: self.store.scope(state: \.profile, action: ExploreAction.profile))
        }
      }
    }
  }

  private var content: some View {
    WithViewStore(self.store) { store in
      ScrollView {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
          ForEachStore(
            self.store.scope(state: \.pagination.items, action: ExploreAction.post(index:action:))
          ) { rowStore in
            WithViewStore(rowStore) { rowViewStore in
              PostView(store: rowStore)
                .onAppear {
                  store.send(.pagination(.next(after: rowViewStore.id)))
                }
            }
          }
        }
        .padding([.leading, .trailing], 10)
        .onAppear {
          store.send(.keychain(.restore))
        }
      }
      .background(colorScheme == .dark ? Color.primaryDark : Color.primaryLight)
    }
  }
}

#if DEBUG
struct ExploreView_Previews: PreviewProvider {
  static var previews: some View {
    let posts = try! KaoriMocks.decode([Post].self, from: "posts", in: .module)
    let states = posts.map(PostState.init(post:))

    let store = Store(
      initialState: ExploreState(
        pagination: PaginationState(items: states)
      ),
      reducer: exploreReducer,
      environment: ExploreEnvironment(
        apiClient: .mock(
          login: { _ in },
          profile: {
            KaoriMocks.decodePublisher(Profile.self, for: "profile", in: .module)
          },
          posts: { _ in
            Just(posts)
              .setFailureType(to: KaoriError.self)
              .eraseToAnyPublisher()
          }
        ),
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
        imagePreheater: .live(),
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
      )
    )

    return ExploreView(store: store)
      .previewLayout(.device)
      .environment(\.colorScheme, .light)
  }
}
#endif
