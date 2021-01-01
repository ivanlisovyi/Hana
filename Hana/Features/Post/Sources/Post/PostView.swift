//
//  PostView.swift
//
//
//  Created by Ivan Lisovyi on 31.12.20.
//

import SwiftUI

import ComposableArchitecture

import Common
import Kaori
import UI

public struct PostView: View {
  @Environment(\.presentationMode) var presentation
  @Environment(\.colorScheme) var colorScheme

  let store: Store<PostState, PostAction>

  public init(store: Store<PostState, PostAction>) {
    self.store = store
  }

  public var body: some View {
    ZStack(alignment: .top) {
      (colorScheme == .dark ? Color.primaryDark : Color.primaryLight)
        .ignoresSafeArea()


      VStack(spacing: 0) {
        NavigationBar {
          leading
        }

        content
      }
    }
    .navigationBarHidden(true)
  }

  private var leading: some View {
    Button(action: {
      presentation.wrappedValue.dismiss()
    }) {
      Image(systemName: "arrow.left")
        .font(.headline)
    }
    .buttonStyle(ShapeBackgroundButtonStyle(shape: Circle()))
  }

  private var content: some View {
    GeometryReader { geometry in
      ScrollView {
        LazyVStack(spacing: 16) {
          WithViewStore(store) { viewStore in
            PostCellView(store: store)
              .displayMode(.large)
              .frame(
                width: geometry.size.width,
                height: geometry.size.width / viewStore.aspectRatio
              )

            info
          }
          Spacer()
        }
        .padding([.leading, .trailing])
      }
      .edgesIgnoringSafeArea(.top)
    }
  }

  private var info: some View {
    WithViewStore(store) { viewStore in
      HStack {
        Group {
          Text(dateFormatter.string(from: viewStore.createdAt))
            .foregroundColor(.secondary)

          Label("\(viewStore.score.total)", systemImage: "arrow.up.arrow.down.circle.fill")
            .foregroundColor(.flamenco)

          Label("\(viewStore.favoritesCount)", systemImage: "heart.fill")
            .foregroundColor(.darkPink)

          Spacer()

          Text("\(viewStore.image.width) x \(viewStore.image.height)")
            .foregroundColor(.secondary)
        }
        .font(.footnote)
      }
      
      Text(viewStore.tags.all.map { "#" + $0 }.joined(separator: " "))
        .font(.caption)
        .foregroundColor(.darkPink)
    }
  }
}

var dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .medium
  formatter.timeStyle = .short
  formatter.doesRelativeDateFormatting = true

  return formatter
}()


#if DEBUG
struct PostView_Previews: PreviewProvider {
  static var previews: some View {
    let post = try! KaoriMocks.decode([Post].self, from: "posts.json", in: .module).first!

    return PostView(
      store: Store(
        initialState: .init(post: post),
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
}
#endif
