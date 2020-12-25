//
//  SwiftUIView.swift
//  
//
//  Created by Ivan Lisovyi on 22.12.20.
//

import SwiftUI

public struct StackNavigationView<Content: View>: View {
  private let content: Content

  public init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  public var body: some View {
    NavigationView {
      content
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}
