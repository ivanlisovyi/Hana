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
  @Environment(\.verticalSizeClass) var sizeClass

  private let store: Store<ExploreState, ExploreAction>

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
    GeometryReader { geometry in
      WithViewStore(store) { viewStore in
        ScrollView {
          LazyVGrid(
            columns: [GridItem(.adaptive(minimum: CGFloat(viewStore.itemSize)))],
            alignment: .leading,
            spacing: 10
          ) {
            ForEachStore(
              store.scope(
                state: \.pagination.items,
                action: ExploreAction.post(index:action:)
              )
            ) { rowStore in
              WithViewStore(rowStore) { rowViewStore in
                PostView(store: rowStore)
                  .displayMode(for: viewStore.itemSize)
                  .onAppear {
                    viewStore.send(.pagination(.next(after: rowViewStore.id)))
                  }
                  .frame(height: CGFloat(viewStore.itemSize) / geometry.aspectRatio)
              }
            }
          }
          .padding([.leading, .trailing], 10)
          .gesture(
            MagnificationGesture.magnification(
              store: store.scope(state: \.magnification, action: ExploreAction.magnification)
            )
          )
        }
        .background(colorScheme == .dark ? Color.primaryDark : Color.primaryLight)
      }
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
