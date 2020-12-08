//
//  ContentView.swift
//  Hana
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import SwiftUI
import ComposableArchitecture

import WebImage

public struct PostsView: View {
  let store: Store<PostsState, PostsAction>

  var columns = [
    GridItem(.adaptive(minimum: 80), spacing: 10)
  ]

  public init(store: Store<PostsState, PostsAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      ScrollView {
        LazyVGrid(columns: columns) {
          ForEach(viewStore.posts) { post in
            WebImage(url: post.image.previewURL)
              .frame(minWidth: 80)
              .frame(height: 160)
              .clipped()
              .id(UUID())
              .onAppear {
                viewStore.send(.fetch(after: post))
              }
          }
        }
      }
      .onAppear {
        viewStore.send(.fetch())
      }
    }
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
