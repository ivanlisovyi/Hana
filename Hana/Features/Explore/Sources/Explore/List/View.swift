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
        NavigationBar {
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
      reducer: Explore.reducer,
      environment: ExploreEnvironment(
        apiClient: .mock(
          posts: { _ in
            Just(posts)
              .setFailureType(to: KaoriError.self)
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
