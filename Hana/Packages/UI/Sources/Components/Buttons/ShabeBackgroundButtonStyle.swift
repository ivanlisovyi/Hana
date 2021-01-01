//
//  SwiftUIView.swift
//  
//
//  Created by Ivan Lisovyi on 01.01.21.
//

import SwiftUI

public struct ShapeBackgroundButtonStyle<S: Shape>: ButtonStyle {
  public let shape: S

  public init(shape: S) {
    self.shape = shape
  }

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(10)
      .background(
        (configuration.isPressed ? Color.darkPink.opacity(0.7) : Color.darkPink)
          .clipShape(shape)
      )
      .foregroundColor(.white)
  }
}

public extension ShapeBackgroundButtonStyle {
  init() where S == Circle {
    self.init(shape: Circle())
  }
}
