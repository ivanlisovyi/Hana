//
//  SwiftUIView.swift
//  
//
//  Created by Ivan Lisovyi on 24.12.20.
//

import SwiftUI

public struct FlowerView: View {
  @Environment(\.colorScheme) var colorScheme

  private let colors: [Color]
  private let angles: [Angle]

  public init(
    colors: [Color] = [.darkPink, .flamenco],
    angles: [Angle] = [
      .degrees(-15),
      .degrees(15),
      .degrees(-30),
      .degrees(30)
    ]
  ) {
    self.colors = colors
    self.angles = angles
  }

  public var body: some View {
    ZStack {
      petal

      ForEach(angles, id: \.self) { angle in
        petal.rotationEffect(angle, anchor: .bottom)
      }
    }
  }

  var petal: some View {
    GeometryReader { geometry in
      let path = Path { path in
        let width = min(geometry.size.width, geometry.size.height)
        let height = width

        path.move(
          to: CGPoint(
            x: width * 0.5,
            y: 0
          )
        )
        path.addQuadCurve(
          to: CGPoint(x: width * 0.5, y: height),
          control: CGPoint(x: width * 0.1, y: height * 0.5)
        )
        path.addQuadCurve(
          to: CGPoint(x: width * 0.5, y: 0),
          control: CGPoint(x: width * 0.9, y: height * 0.5)
        )
      }

      ZStack {
        path.fill(
          LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .opacity(0.8)

        path.stroke(Color.white.opacity(0.2))
      }
    }
  }
}

#if DEBUG
struct FlowerView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      FlowerView()
        .frame(width: 140, height: 140)
        .colorScheme(.dark)

      FlowerView()
        .frame(width: 30, height: 30)
        .colorScheme(.light)
    }

  }
}
#endif
