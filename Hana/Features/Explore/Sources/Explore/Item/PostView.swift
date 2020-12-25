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

  public init(store: Store<PostState, PostAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      ZStack {
        WebImage(url: viewStore.post.image.url)
          .resized(width: 300)
          .frame(
            height: CGFloat(300) / CGFloat(viewStore.post.image.width) * CGFloat(viewStore.post.image.height)
          )
          .clipped()

        bottomView
      }
      .frame(
        height: CGFloat(300) / CGFloat(viewStore.post.image.width) * CGFloat(viewStore.post.image.height)
      )
      .background(Color(.secondarySystemBackground))
      .clipShape(RoundedRectangle(cornerRadius: 10, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
    }
  }

  public var bottomView: some View {
    VStack {
      Spacer()

      HStack {
        Spacer()

        FavoriteView(
          store: self.store.scope(state: { $0.favorite }, action: PostAction.favorite)
        )
      }
      .padding()
    }
  }
}

#if DEBUG
struct PostView_Previews: PreviewProvider {
  static var previews: some View {
    let post = try! Kaori.decodeMock(of: [Post].self, for: "posts.json", in: Bundle.module).first!

    return VStack {
      PostView(
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
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
