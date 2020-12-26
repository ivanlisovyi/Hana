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
  let store: Store<ExploreState, ExploreAction>

  @State var isAnimating = false

  private var columns = [
    GridItem(.adaptive(minimum: 300), alignment: .top)
  ]

  public init(store: Store<ExploreState, ExploreAction>) {
    self.store = store
  }

  public var body: some View {
    Navigation {
      leading
    } trailing: {
      trailing
    } content: {
      content
    }
  }

  private var leading: some View {
    WithViewStore(self.store) { viewStore in
      Button(action: { viewStore.send(.fetch) }) {
        FlowerView()
          .frame(width: 30, height: 30, alignment: .center)
      }
    }
  }

  private var trailing: some View {
    WithViewStore(self.store) { viewStore in
      Button(action: { viewStore.send(.setSheet(isPresented: true)) }) {
        Image(systemName: "person.crop.circle")
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
            self.store.scope(state: \.posts, action: ExploreAction.post(index:action:))
          ) { rowStore in
            WithViewStore(rowStore) { rowViewStore in
              PostView(store: rowStore)
                .onAppear {
                  store.send(.fetchNext(after: rowViewStore.state))
                }
            }
          }
        }
        .padding([.leading, .trailing], 10)
      }
      .onAppear {
        store.send(.onAppear)
      }
    }
  }
}

#if DEBUG
struct ExploreView_Previews: PreviewProvider {
  static var previews: some View {
    let states = try! KaoriMocks.decode([Post].self, from: .posts)
      .map(PostState.init(post:))

    let store = Store(
      initialState: ExploreState(posts: states),
      reducer: exploreReducer,
      environment: ExploreEnvironment(
        apiClient: .mock(
          login: { _ in },
          profile: {
            KaoriMocks.decodePublisher(Profile.self, from: .profile)
          },
          posts: { _ in
            KaoriMocks.decodePublisher([Post].self, from: .posts)
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
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
      )
    )

    return ExploreView(store: store)
      .previewLayout(.device)
      .environment(\.colorScheme, .light)
  }
}
#endif
