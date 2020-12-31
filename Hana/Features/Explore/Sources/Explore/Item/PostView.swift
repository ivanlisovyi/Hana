//
//  PostView.swift
//  
//
//  Created by Ivan Lisovyi on 13.12.20.
//

import SwiftUI
import ComposableArchitecture

import Kaori
import UI

public struct PostView: View {
  public enum DisplayMode: Equatable {
    case `default`
    case large
  }

  public let store: Store<PostState, PostAction>

  @State var size: CGSize = .zero

  var displayMode: DisplayMode = .default

  public init(store: Store<PostState, PostAction>) {
    self.store = store
  }

  public var body: some View {
    GeometryReader { geometry in
      WithViewStore(store) { viewStore in

        Kitsu.Image(url: displayMode == .default ? viewStore.image.previewURL : viewStore.image.url)
          .frame(width: geometry.size.width, height: geometry.size.height)
          .if(displayMode == .large) { $0.overlay(bottomView, alignment: .bottomTrailing) }
          .contentShape(Rectangle())
          .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
          .animation(.default)
      }
    }
  }

  private var bottomView: some View {
    FavoriteView(
      store: store.scope(state: { $0.favorite }, action: PostAction.favorite)
    )
    .frame(width: 40, height: 40)
    .padding(10)
  }
}

extension PostView {
  func displayMode(_ mode: DisplayMode) -> Self {
    var view = self
    view.displayMode = mode
    return view
  }

  func displayMode(for width: Int) -> Self {
    let mode: DisplayMode = width >= 150 ? .large : .default
    return displayMode(mode)
  }
}

#if DEBUG
struct PostView_Previews: PreviewProvider {
  static var previews: some View {
    let post = try! KaoriMocks.decode([Post].self, from: "posts", in: .module).first!

    return PostView(
      store: Store(
        initialState: PostState(post: post),
        reducer: postReducer,
        environment: PostEnvironment(
          favorite: { _, isFavorite in
            return Effect(value: isFavorite)
          },
          mainQueue: DispatchQueue.main.eraseToAnyScheduler()
        )
      )
    )
    .previewLayout(.sizeThatFits)
  }
}
#endif
