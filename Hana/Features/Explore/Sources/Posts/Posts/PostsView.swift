//
//  PostsView.swift
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

import Post

public struct PostsView: View {
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.verticalSizeClass) var sizeClass

  private let store: Store<PostsState, PostsAction>

  public init(store: Store<PostsState, PostsAction>) {
    self.store = store
  }

  public var body: some View {
    ZStack {
      (colorScheme == .dark ? Color.primaryDark : Color.primaryLight)
        .ignoresSafeArea()

      content
    }
    .navigationBarItems(leading: leading)
    .navigationBarColor(colorScheme == .dark ? .primaryDark : .primaryLight)
  }

  private var leading: some View {
    WithViewStore(self.store) { viewStore in
      Button(action: { viewStore.send(.pagination(.first)) }) {
        FlowerView().frame(width: 30, height: 30)
      }
    }
  }

  private var content: some View {
    WithViewStore(store) { viewStore in
      ScrollView(isRefreshing: viewStore.isRefreshing) {
        Group {
          LazyVGrid(
            columns: [GridItem(.adaptive(minimum: CGFloat(viewStore.layout.size)))],
            alignment: .leading,
            spacing: CGFloat(viewStore.layout.spacing)
          ) {
            items(viewStore)
          }
          .highPriorityGesture(
            MagnificationGesture.magnification(
              store: store.scope(state: \.magnification, action: PostsAction.magnification)
            )
          )
        }
        .padding([.leading, .trailing, .top], 10)
      }
    }
  }

  @ViewBuilder private func items(_ viewStore: ViewStore<PostsState, PostsAction>) -> some View {
    if viewStore.isEmpty {
      ForEach(0..<10) { _ in
        PostCellView.placeholder
          .displayMode(for: viewStore.layout.size)
          .frame(height: CGFloat(viewStore.layout.size))
      }
      .redacted(reason: .placeholder)
    } else {
      ForEachStore(
        store.scope(
          state: \.pagination.items,
          action: PostsAction.post(index:action:)
        )
      ) { rowStore in
        NavigationLink(
          destination: PostView(store: rowStore)
        ) {
          PostCellView(store: rowStore)
            .displayMode(for: viewStore.layout.size)
            .frame(height: CGFloat(viewStore.layout.size))
        }
        .buttonStyle(UnstyledButtonStyle())
      }
    }
  }
}

extension ViewStore where State == PostsState, Action == PostsAction {
  var isRefreshing: Binding<Bool> {
    self.binding(get: \.isRefreshing, send: PostsAction.pagination(.first))
  }
}

#if DEBUG
struct PostsView_Previews: PreviewProvider {
  static var previews: some View {
    let posts = try! KaoriMocks.decode([Post].self, from: "posts", in: .module)
    let states = posts.map { post in PostState(post: post, isFavoritingEnabled: true) }

    let store = Store(
      initialState: PostsState(
        pagination: PaginationState(items: states)
      ),
      reducer: Posts.reducer,
      environment: PostsEnvironment(
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

    return PostsView(store: store)
      .previewLayout(.device)
      .environment(\.colorScheme, .light)
  }
}
#endif
