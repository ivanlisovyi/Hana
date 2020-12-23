//
//  PostView.swift
//  
//
//  Created by Ivan Lisovyi on 13.12.20.
//

import SwiftUI
import ComposableArchitecture

import Kaori
import WebImage

import ViewModifiers

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
          .frame(minHeight: (CGFloat(300) / CGFloat(viewStore.post.image.width)) * CGFloat(viewStore.post.image.height))
          .clipped()
          .clipShape(RoundedRectangle.init(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))

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
  }
}
