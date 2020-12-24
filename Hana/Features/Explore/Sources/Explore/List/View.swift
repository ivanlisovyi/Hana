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

import Login
import Profile

public struct ExploreView: View {
  let store: Store<ExploreState, ExploreAction>

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

  @ViewBuilder private var leading: some View {
    Text("New")
      .font(.largeTitle)
      .fontWeight(.bold)
  }

  @ViewBuilder private var trailing: some View {
    WithViewStore(self.store) { viewStore in
      Button(action: { viewStore.send(.setSheet(isPresented: true)) }) {
        Image(systemName: "person.crop.circle")
          .font(.title)
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
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let posts = try! Kaori.decodeMock(of: [Post].self, for: "posts.json", in: Bundle.module)
    let states = posts.map(PostState.init(post:))

    let store = Store(
      initialState: ExploreState(posts: states),
      reducer: exploreReducer,
      environment: ExploreEnvironment(
        apiClient: .mock(posts: { _ in
          Kaori.decodeMockPublisher(of: [Post].self, for: "posts.json", in: Bundle.module)
        }),
        keychain: .mock(
          save: { _ in
            Empty(completeImmediately: true)
              .eraseToAnyPublisher()
          },
          retrieve: {
            Empty(completeImmediately: true)
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
