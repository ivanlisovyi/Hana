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
    GridItem(.flexible(minimum: 300))
  ]

  public init(store: Store<ExploreState, ExploreAction>) {
    self.store = store
  }

  public var body: some View {
    VStack {
      header
      content
    }
  }

  @ViewBuilder private var header: some View {
    WithViewStore(self.store) { store in
      HStack {
        Text("New")
          .font(.largeTitle)
          .fontWeight(.bold)

        Spacer()

        Button(action: { store.send(.setSheet(isPresented: true)) }) {
          Image(systemName: "person.crop.circle")
            .font(.largeTitle)
        }
      }
      .sheet(
        isPresented: store.binding(
          get: { $0.isSheetPresented },
          send: ExploreAction.setSheet(isPresented:)
        )
      ) {
        StackNavigationView {
          ProfileView(store: self.store.scope(state: \.profile, action: ExploreAction.profile))
        }
      }
      .padding()
    }
  }

  private var content: some View {
    WithViewStore(self.store) { store in
      ScrollView {
        LazyVGrid(columns: columns, spacing: 10) {
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
        store.send(.fetch)
      }
    }
  }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let store = Store(
      initialState: ExploreState(),
      reducer: exploreReducer,
      environment: ExploreEnvironment(
        apiClient: .mock(posts: { _ in
          Kaori.decodeMockPublisher(of: [Post].self, for: "posts.json", in: Bundle.module)
        }),
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
      )
    )

    return ExploreView(store: store)
      .previewLayout(.device)
      .environment(\.colorScheme, .light)
  }
}
#endif
