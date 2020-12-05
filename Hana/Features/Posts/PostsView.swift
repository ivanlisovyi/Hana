//
//  ContentView.swift
//  Hana
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import SwiftUI
import ComposableArchitecture

import SDWebImageSwiftUI

struct PostsView: View {
  let store: Store<PostsState, PostsAction>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      ScrollView {
        LazyVStack {
          ForEach(viewStore.posts, id: \.id) { post in
            VStack {
              WebImage(url: post.fileUrl, options: .scaleDownLargeImages)
                .resizable()
                .placeholder {
                  Rectangle().foregroundColor(.gray)
                }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: 300, height: 300, alignment: .center)
            }
          }
        }
      }
      .onAppear {
        viewStore.send(.fetch)
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
