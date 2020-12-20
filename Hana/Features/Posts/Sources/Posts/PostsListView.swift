//
//  ContentView.swift
//  Hana
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import SwiftUI
import Combine

import ComposableArchitecture

import Kaori
import Login

public struct PostsView: View {
  let store: Store<PostsState, PostsAction>

  @State var showProfile = false

  private var columns = [
    GridItem(.flexible(minimum: 300))
  ]

  public init(store: Store<PostsState, PostsAction>) {
    self.store = store
  }

  public var body: some View {
    VStack {
      header
      content
    }
  }

  @ViewBuilder private var header: some View {
    HStack {
      Text("New")
        .font(.largeTitle)
        .fontWeight(.bold)

      Spacer()

      Button(action: { showProfile.toggle() }) {
        Image(systemName: "person.crop.circle")
          .font(.largeTitle)
      }
    }
    .sheet(isPresented: $showProfile) {
      IfLetStore(self.store.scope(state: { $0.login }, action: PostsAction.login)) { store in
        NavigationView {
          LoginView(store: store)
        }
        .navigationViewStyle(StackNavigationViewStyle())
      }
    }
    .padding()
  }

  private var content: some View {
    WithViewStore(self.store) { store in
      ScrollView {
        LazyVGrid(columns: columns, spacing: 10) {
          ForEach(store.posts, id: \.id) { post in
            PostView(image: post.image)
              .onAppear {
                store.send(.fetchNext(after: post))
              }
          }
        }
        .padding([.leading, .trailing], 10)
      }
      .onAppear {
        store.send(.fetch)
      }
    }
  }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let store = Store(
      initialState: PostsState(login: LoginState()),
      reducer: postsReducer,
      environment: PostsEnvironment(
        apiClient: .mock(posts: { _ in
          guard let json = Bundle.module.url(forResource: "posts", withExtension: "json"),
                let data = try? Data(contentsOf: json) else {
            return Fail(error: Kaori.KaoriError.network)
              .eraseToAnyPublisher()
          }

          let dateFormatter = DateFormatter()
          dateFormatter.locale = .autoupdatingCurrent
          dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

          let decoder = JSONDecoder()
          decoder.dateDecodingStrategy = .formatted(dateFormatter)
          decoder.keyDecodingStrategy = .convertFromSnakeCase

          guard let posts = try? decoder.decode([Post].self, from: data) else {
            return Fail(error: Kaori.KaoriError.decoding)
              .eraseToAnyPublisher()
          }

          return Just(posts)
            .setFailureType(to: Kaori.KaoriError.self)
            .eraseToAnyPublisher()
        }),
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
      )
    )

    return PostsView(store: store)
      .previewLayout(.device)
      .environment(\.colorScheme, .light)
  }
}
#endif
