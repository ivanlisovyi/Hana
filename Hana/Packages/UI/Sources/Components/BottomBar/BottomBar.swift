//
//  BottomBar.swift
//
//
//  Created by Ivan Lisovyi on 27.12.20.
//

import SwiftUI

public struct BottomBar : View {
  @_functionBuilder
  public struct BarBuilder {
    public static func buildBlock(_ items: BottomBarItem...) -> [BottomBarItem] {
      items
    }
  }

  @Environment(\.colorScheme) var colorScheme

  @Binding public var selectedIndex: Int

  public let items: [BottomBarItem]

  public init(
    selectedIndex: Binding<Int>,
    @BarBuilder items: () -> [BottomBarItem]
  ) {
    self._selectedIndex = selectedIndex
    self.items = items()
  }

  public var body: some View {
    GeometryReader { geometry in
      ZStack {
        (colorScheme == .dark ? Color.primaryDark : Color.primaryLight)
          .ignoresSafeArea()

        HStack(spacing: 0) {
          ForEach(0..<items.count) { index in
            self.itemView(at: index)
              .frame(width: geometry.size.width / CGFloat(items.count))
          }
        }
      }
      .animation(.default)
      .edgesIgnoringSafeArea([.leading, .trailing])
    }
    .frame(height: 40)
  }

  private func itemView(at index: Int) -> some View {
    Button(action: {
      withAnimation { self.selectedIndex = index }
    }) {
      BottomBarItemView(selected: self.$selectedIndex,
                        index: index,
                        item: items[index])
    }
  }

}

#if DEBUG
struct BottomBar_Previews : PreviewProvider {
  struct Screen: View {
    @State var selected = 0

    let colors: [Color] = [.purple, .pink, .orange, .blue]

    var body: some View {
      VStack(spacing: 0) {
        Color.white.ignoresSafeArea()

        BottomBar(selectedIndex: $selected) {
          BottomBarItem(icon: "square.stack", text: "Explore", color: .darkPink)
          BottomBarItem(icon: "heart", text: "Likes", color: .darkPink)
          BottomBarItem(icon: "person", text: "Profile", color: .darkPink)
        }
      }
      .frame(maxWidth: .infinity)
    }
  }

  static var previews: some View {
    Screen()
  }
}
#endif
