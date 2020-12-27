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

  public init(selectedIndex: Binding<Int>, items: [BottomBarItem]) {
    self._selectedIndex = selectedIndex
    self.items = items
  }

  public init(selectedIndex: Binding<Int>, @BarBuilder items: () -> [BottomBarItem]) {
    self = BottomBar(selectedIndex: selectedIndex,
                     items: items())
  }

  public init(selectedIndex: Binding<Int>, item: BottomBarItem) {
    self = BottomBar(selectedIndex: selectedIndex,
                     items: [item])
  }

  func itemView(at index: Int) -> some View {
    Button(action: {
      withAnimation { self.selectedIndex = index }
    }) {
      BottomBarItemView(selected: self.$selectedIndex,
                        index: index,
                        item: items[index])
    }
  }

  public var body: some View {
    GeometryReader { geometry in
      HStack(alignment: .center) {
        ForEach(0..<items.count) { index in
          self.itemView(at: index)

          if index != self.items.count - 1 {
            Spacer()
          }
        }
      }
      .padding(
        EdgeInsets(
          top: 0,
          leading: geometry.safeAreaInsets.leading + 16,
          bottom: geometry.safeAreaInsets.bottom,
          trailing: geometry.safeAreaInsets.trailing + 16
        )
      )
      .animation(.default)
      .background(colorScheme == .dark ? Color.primaryDark : Color.primaryLight)
      .edgesIgnoringSafeArea([.leading, .trailing])
    }
    .frame(height: 40)
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
