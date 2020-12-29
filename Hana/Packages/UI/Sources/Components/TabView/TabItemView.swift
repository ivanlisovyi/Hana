//
//  TabItemView.swift
//
//
//  Created by Ivan Lisovyi on 27.12.20.
//

import SwiftUI

public struct TabItemView<Content: View>: View {
  @Binding var selected : Int
  public let index: Int
  public let item: TabItem<Content>

  public var body: some View {
    item.content(isSelected)
  }

  var isSelected : Bool {
    selected == index
  }
}

#if DEBUG
struct BottomBarItemView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      TabItemView(
        selected: .constant(0),
        index: 0,
        item: .init { _ in Image(systemName: "heart").padding() }
      )
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
