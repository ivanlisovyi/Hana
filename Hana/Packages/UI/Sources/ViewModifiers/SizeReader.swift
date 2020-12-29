//
//  SizeModifier.swift
//  
//
//  Created by Ivan Lisovyi on 25.12.20.
//

import SwiftUI

public struct SizePreferenceKey: PreferenceKey {
  public static var defaultValue: CGSize = .zero

  public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    _ = nextValue()
  }
}

public struct SizeModifier: ViewModifier {
  private var sizeView: some View {
    GeometryReader { geometry in
      Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
    }
  }

  public func body(content: Content) -> some View {
    content.background(sizeView)
  }
}

public extension View {
  func onSizeChange(_ perform: @escaping (CGSize) -> Void) -> some View {
    self.modifier(SizeModifier())
      .onPreferenceChange(SizePreferenceKey.self, perform: perform)
  }
}
