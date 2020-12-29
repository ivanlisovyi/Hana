//
//  HStackSelection.swift
//  
//
//  Created by Ivan Lisovyi on 29.12.20.
//

import SwiftUI

public extension HStack {
  func selection(width: CGFloat, spacing: CGFloat, selection: Binding<Int>) -> some View {
    self.modifier(HStackSelectionModifier(width: width, spacing: spacing, selection: selection))
  }
}

public struct HStackSelectionModifier: ViewModifier {
  @Binding private var selection: Int

  public var width: CGFloat
  public var spacing: CGFloat

  public init(
    width: CGFloat,
    spacing: CGFloat,
    selection: Binding<Int>
  ) {
    self.width = width
    self.spacing = spacing

    self._selection = selection
  }

  public func body(content: Content) -> some View {
    let offset = -CGFloat(selection) * (width + spacing)
    return content.offset(x: offset, y: 0).animation(.none)
  }
}
