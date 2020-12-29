//
//  TabView.swift
//
//
//  Created by Ivan Lisovyi on 27.12.20.
//

import SwiftUI

public struct TabView<Content: View, Style: TabViewStyle>: View {
  @_functionBuilder
  public struct TabBarBuilder {
    public static func buildBlock(_ items: TabItem<Content>...) -> [TabItem<Content>] {
      items
    }
  }

  @Environment(\.colorScheme) var colorScheme
  @Binding public var selectedIndex: Int

  public let content: () -> [TabItem<Content>]
  public let style: Style

  private let items: [TabItem<Content>]

  public init(
    selectedIndex: Binding<Int>,
    @TabBarBuilder content: @escaping () -> [TabItem<Content>]
  ) where Style == DefaultTabViewStyle {
    self.init(
      selectedIndex: selectedIndex,
      style: DefaultTabViewStyle(),
      content: content
    )
  }

  public init(
    selectedIndex: Binding<Int>,
    style: Style,
    @TabBarBuilder content: @escaping () -> [TabItem<Content>]
  ) {
    self._selectedIndex = selectedIndex
    self.style = style
    self.content = content
    self.items = content()
  }

  public var body: some View {
    HStack(spacing: style.spacing) {
      ForEach(0..<items.count) { index in
        itemView(at: index)
      }

      if style is PagedTabViewStyle {
        Spacer()
      }
    }
    .overlayPreferenceValue(AnchorKey.self, {
      style.indicator(with: $0)
    })
    .padding([.leading, .trailing], 16)
  }

  private func itemView(at index: Int) -> some View {
    Button(action: {
      withAnimation { selectedIndex = index }
    }) {
      TabItemView(
        selected: $selectedIndex,
        index: index,
        item: items[index]
      )
    }
    .anchorPreference(
      key: AnchorKey.self,
      value: .bounds,
      transform: { selectedIndex == index ? $0 : nil}
    )
    .accentColor(index == selectedIndex ? .darkPink : .primary)
  }
}

public extension TabView {
  func tabViewStyle<S: TabViewStyle>(_ style: S) -> TabView<Content, S> {
    TabView<Content, S>(selectedIndex: $selectedIndex, style: style, content: content)
  }
}

public protocol TabViewStyle {
  associatedtype Indicator: View

  var spacing: CGFloat { get }

  func indicator(with bounds: Anchor<CGRect>?) -> Indicator
}

public struct DefaultTabViewStyle: TabViewStyle {
  public let spacing: CGFloat = 40

  public init() {}

  public func indicator(with bounds: Anchor<CGRect>?) -> some View {
    GeometryReader { proxy in
      if bounds != nil {
        Rectangle()
          .fill(Color.darkPink)
          .frame(width: proxy[bounds!].width, height: 1)
          .offset(x: proxy[bounds!].minX, y: 0)
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
      }
    }
  }
}

public struct PagedTabViewStyle: TabViewStyle {
  public let spacing: CGFloat = 10

  public init() {}

  public func indicator(with bounds: Anchor<CGRect>?) -> some View {
    GeometryReader { proxy in
      if bounds != nil {
        Capsule()
          .fill(Color.darkPink.opacity(0.2))
          .frame(width: proxy[bounds!].width, height: proxy[bounds!].height)
          .offset(x: proxy[bounds!].minX, y: 0)
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
      }
    }
  }
}

private struct AnchorKey: PreferenceKey {
  static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
    value = value ?? nextValue()
  }
}

#if DEBUG
struct TabBar_Previews : PreviewProvider {
  struct Screen: View {
    @State var selected = 0

    var body: some View {
      VStack(spacing: 10) {
        Color.white.ignoresSafeArea()

        TabView(selectedIndex: $selected) {
          TabItem { imageTab(systemName: "square.stack", isSelected: $0) }
          TabItem { imageTab(systemName: "heart", isSelected: $0) }
          TabItem { imageTab(systemName: "person", isSelected: $0) }
        }

        TabView(selectedIndex: $selected) {
          TabItem { textTabItem(text: "New", isSelected: $0) }
          TabItem { textTabItem(text: "Favorites", isSelected: $0) }
          TabItem { textTabItem(text: "Updated", isSelected: $0) }
        }.tabViewStyle(PagedTabViewStyle())
      }
      .frame(maxWidth: .infinity)
    }

    private func imageTab(systemName: String, isSelected: Bool) -> some View {
      Image(systemName: systemName)
        .imageScale(.large)
        .foregroundColor(isSelected ? .darkPink : .primary)
        .padding()
    }

    private func textTabItem(text: String, isSelected: Bool) -> some View {
      Text(text)
        .font(.subheadline)
        .foregroundColor(isSelected ? .darkPink : .secondary)
        .padding()
    }
  }

  static var previews: some View {
    Screen()
  }
}
#endif
