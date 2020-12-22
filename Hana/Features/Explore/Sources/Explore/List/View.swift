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

  @SwiftUI.State var showProfile = false

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
        if store.profile != nil {
          IfLetStore(self.store.scope(state: { $0.profile }, action: ExploreAction.profile)) { store in
            StackNavigationView {
              ProfileView(store: store)
            }
          }
        } else {
          IfLetStore(self.store.scope(state: { $0.login }, action: ExploreAction.login)) { store in
            StackNavigationView {
              LoginView(store: store)
            }
          }
        }
      }
      .padding()
    }
  }

  private var content: some View {
    WithViewStore(self.store) { store in
      ScrollView {
        LazyVGrid(columns: columns, spacing: 10) {
          ForEach(store.posts, id: \.id) { post in
            ItemView(image: post.image)
              .onAppear {
                store.send(.fetchNext(after: post))
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
      initialState: ExploreState(login: LoginState()),
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
