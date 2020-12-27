//
//  BottomBarItemView.swift
//
//
//  Created by Ivan Lisovyi on 27.12.20.
//

import SwiftUI

public struct BottomBarItemView: View {
  @Binding var selected : Int
  public let index: Int
  public let item: BottomBarItem

  public var body: some View {
    HStack {
      item.icon
        .imageScale(.large)
        .foregroundColor(isSelected ? item.color : .primary)

      if isSelected {
        Text(item.text)
          .foregroundColor(isSelected ? item.color : .primary)
          .font(.caption)
          .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
      }
    }
    .padding()
  }

  var isSelected : Bool {
    selected == index
  }
}

#if DEBUG
struct BottomBarItemView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      BottomBarItemView(
        selected: .constant(0),
        index: 0,
        item: .init(icon: "heart", text: "Likes", color: .darkPink)
      )
      BottomBarItemView(
        selected: .constant(1),
        index: 0,
        item: .init(icon: "heart", text: "Likes", color: .darkPink)
      )
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
