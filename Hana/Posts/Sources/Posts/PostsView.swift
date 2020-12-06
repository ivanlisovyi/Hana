//
//  ContentView.swift
//  Hana
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import SwiftUI
import ComposableArchitecture

import SDWebImageSwiftUI

public struct PostsView: View {
  let store: Store<PostsState, PostsAction>

  public init(store: Store<PostsState, PostsAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      ScrollView {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 30), count: 2), spacing: 30) {
          ForEach(viewStore.posts, id: \.md5) { post in
            VStack {
              WebImage(url: post.previewFileUrl)
                .resizable()
                .placeholder {
                  Rectangle().foregroundColor(.gray)
                }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
            }
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
