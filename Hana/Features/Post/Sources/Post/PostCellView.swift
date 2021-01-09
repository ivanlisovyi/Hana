//
//  PostCellView.swift
//  
//
//  Created by Ivan Lisovyi on 13.12.20.
//

import SwiftUI
import ComposableArchitecture

import Kaori
import UI

public struct PostCellView: View {
  public enum DisplayMode: Equatable {
    case `default`
    case large
  }

  @Environment(\.postDisplayMode) var displayMode

  public let store: Store<PostState, PostAction>

  public init(store: Store<PostState, PostAction>) {
    self.store = store
  }

  public var body: some View {
    GeometryReader { geometry in
      WithViewStore(store) { viewStore in
        Kitsu.Image(
          url: displayMode == .default ? viewStore.image.previewURL : viewStore.image.url
        )
        .frame(width: geometry.size.width, height: geometry.size.height)
        .if(viewStore.isFavoritingEnabled) { $0.overlay(bottomView, alignment: .bottomTrailing) }
        .contentShape(Rectangle())
        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
        .onAppear {
          viewStore.send(.onAppear(id: viewStore.id))
        }
      }
    }
  }

  private var bottomView: some View {
    FavoriteButton(
      store: store.scope(state: { $0.favorite }, action: PostAction.favorite)
    )
    .if(displayMode == .default) {
      $0.buttonStyle(PlainFavoriteButtonStyle())
    } else: {
      $0.buttonStyle(ShapeBackgroundButtonStyle())
    }
    .padding(10)
  }
}

public extension PostCellView {
  func displayMode(_ mode: DisplayMode) -> some View {
    self.environment(\.postDisplayMode, mode)
  }

  func displayMode(for width: Int) -> some View {
    let mode: DisplayMode = width >= 150 ? .large : .default
    return displayMode(mode)
  }
}

extension EnvironmentValues {
  var postDisplayMode: PostCellView.DisplayMode {
    get {
      return self[PostItemDisplayModeKey.self]
    }
    set {
      self[PostItemDisplayModeKey.self] = newValue
    }
  }
}

struct PostItemDisplayModeKey: EnvironmentKey {
  static let defaultValue: PostCellView.DisplayMode = .default
}

extension PostCellView {
  public static var placeholder: Self {
    PostCellView(
      store: Store(
        initialState: PostState(post: .mock, isFavoritingEnabled: true),
        reducer: postReducer,
        environment:
          PostEnvironment(
            favorite: { _, _ in fatalError() },
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
          )
      )
    )
  }
}

#if DEBUG
struct PostCellView_Previews: PreviewProvider {
  static var previews: some View {
    let post = try! KaoriMocks.decode([Post].self, from: "posts.json", in: .module).first!
    let aspectRatio = CGFloat(post.image.width) / CGFloat(post.image.height)

    let item = PostCellView(
      store: Store(
        initialState: .init(post: post, isFavoritingEnabled: true),
        reducer: postReducer,
        environment: PostEnvironment(
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
