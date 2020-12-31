//
//  PostItemView.swift
//  
//
//  Created by Ivan Lisovyi on 13.12.20.
//

import SwiftUI
import ComposableArchitecture

import Kaori
import UI

public struct PostItemView: View {
  public enum DisplayMode: Equatable {
    case `default`
    case large
  }

  @Environment(\.postDisplayMode) var displayMode

  public let store: Store<PostItemState, PostItemAction>

  public init(store: Store<PostItemState, PostItemAction>) {
    self.store = store
  }

  public var body: some View {
    GeometryReader { geometry in
      WithViewStore(store) { viewStore in
        Kitsu.Image(url: displayMode == .default ? viewStore.image.previewURL : viewStore.image.url)
          .frame(width: geometry.size.width, height: geometry.size.height)
          .overlay(bottomView, alignment: .bottomTrailing)
          .contentShape(Rectangle())
          .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
          .animation(.default)
      }
    }
  }

  private var bottomView: some View {
    FavoriteButton(
      store: store.scope(state: { $0.favorite }, action: PostItemAction.favorite)
    )
    .if(displayMode == .default) {
      $0.buttonStyle(PlainFavoriteButtonStyle())
    } else: {
      $0.buttonStyle(ShapeBackgroundFavoriteButtonStyle())
    }
    .padding(10)
  }
}

extension PostItemView {
  func displayMode(_ mode: DisplayMode) -> some View {
    self.environment(\.postDisplayMode, mode)
  }

  func displayMode(for width: Int) -> some View {
    let mode: DisplayMode = width >= 150 ? .large : .default
    return displayMode(mode)
  }
}

extension EnvironmentValues {
  var postDisplayMode: PostItemView.DisplayMode {
    get {
      return self[PostItemDisplayModeKey.self]
    }
    set {
      self[PostItemDisplayModeKey.self] = newValue
    }
  }
}

struct PostItemDisplayModeKey: EnvironmentKey {
  static let defaultValue: PostItemView.DisplayMode = .default
}

#if DEBUG
struct PostView_Previews: PreviewProvider {
  static var previews: some View {
    let post = try! KaoriMocks.decode([Post].self, from: "posts.json", in: .module).first!
    let aspectRatio = CGFloat(post.image.width) / CGFloat(post.image.height)

    let item = PostItemView(
      store: Store(
        initialState: PostItemState(post: post),
        reducer: postItemReducer,
        environment: PostItemEnvironment(
          favorite: { _, isFavorite in
            return Effect(value: isFavorite)
          },
          mainQueue: DispatchQueue.main.eraseToAnyScheduler()
        )
      )
    )

    return Group {
      item
        .displayMode(.large)
        .frame(width: 300.0, height: 300 / aspectRatio)

      item
        .displayMode(.default)
        .frame(width: 100, height: 150)
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
