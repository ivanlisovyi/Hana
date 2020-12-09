//
//  ContentView.swift
//  Hana
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import SwiftUI
import ComposableArchitecture

import Kaori

import WebImage
import ViewModifiers
import Extensions

public struct PostsView: View {
  let store: Store<PostsState, PostsAction>

  var columns = [
    GridItem(.adaptive(minimum: 300), spacing: 10, alignment: .center)
  ]

  public init(store: Store<PostsState, PostsAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      ScrollView {
        LazyVGrid(columns: columns, spacing: 10) {
          ForEach(viewStore.posts, id: \.id) { post in
            item(for: post)
              .onAppear {
                viewStore.send(.fetchNext(after: post))
              }
          }
        }
      }
      .onAppear {
        viewStore.send(.fetch)
      }
    }
  }

  private func item(for post: Post) -> some View {
    WebImage(url: post.image.previewURL)
      .frame(minHeight: 300)
      .if(post.isNSFW) { $0.nsfw() }
      .clipped()
  }
}

extension View {
  func nsfw() -> some View {
    modifier(NSFW())
  }
}

//
//#if DEBUG
//struct ContentView_Previews: PreviewProvider {
//  static var previews: some View {
//
//
//    PostsView()
//  }
//}
//#endif
