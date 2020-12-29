//
//  NSFW.swift
//  
//
//  Created by Ivan Lisovyi on 09.12.20.
//

import SwiftUI

public struct NSFW: ViewModifier {
  @State var isVisible: Bool = false

  public init() {}

  public func body(content: Content) -> some View {
    ZStack(alignment: .center) {
      if isVisible {
        content
      } else {
        content.layoutPriority(1)
          .blur(radius: 10)
          .clipped()
        VStack {
          Image(systemName: "eye.slash.fill")
            .foregroundColor(.white)
          Text("NSFW")
            .font(.caption)
            .bold()
            .foregroundColor(.white)
        }
      }
    }
    .onTapGesture {
      withAnimation {
        self.isVisible.toggle()
      }
    }
  }
}

public extension Image {
  func nsfw() -> some View {
    self.modifier(NSFW())
  }
}
