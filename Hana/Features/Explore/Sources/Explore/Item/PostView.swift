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
  public let store: Store<PostState, PostAction>

  @State var size: CGSize = .zero

  public init(store: Store<PostState, PostAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      ZStack(alignment: .bottomTrailing) {
        WebImage(url: viewStore.post.image.url)
          .resized(width: size.width)
        bottomView
      }
      .background(Color(.secondarySystemBackground))
      .onSizeChange {
        if !$0.equalTo(size) {
          size = $0
        }
      }
      .frame(height: size.width / viewStore.aspectRatio)
      .clipShape(RoundedRectangle(cornerRadius: 10, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
//      .contextMenu(
//        ContextMenu(menuItems: {
//          shareButton
//        })
//      )
    }
  }

  private var bottomView: some View {
    VStack {
      Spacer()

      HStack {
        Spacer()

        FavoriteView(
          store: self.store.scope(state: { $0.favorite }, action: PostAction.favorite)
        )
        .frame(width: 40, height: 40)
      }
      .padding()
    }
  }

  private var shareButton: some View {
    Button(action: {}, label: {
      HStack {
        Image(systemName: "square.and.arrow.down")
        Text("Download")
      }
    })
  }
}

#if DEBUG
struct PostView_Previews: PreviewProvider {
  static var previews: some View {
    let post = try! KaoriMocks.decode([Post].self, from: .posts).first!

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
