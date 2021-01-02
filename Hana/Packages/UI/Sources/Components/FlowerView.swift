//
//  SwiftUIView.swift
//  
//
//  Created by Ivan Lisovyi on 24.12.20.
//

import SwiftUI

import DesignSystem
import Extensions

public struct FlowerView: View {
  @Environment(\.colorScheme) var colorScheme

  @Binding var isVisible: Bool
  @Binding var isAnimationEnabled: Bool

  @State var isAnimating: Bool = false

  private let colors: [Color]
  private let angles: [Angle]

  public init(
    isVisible: Binding<Bool> = .constant(true),
    isAnimationEnabled: Binding<Bool> = .constant(false),
    colors: [Color] = [.darkPink, .flamenco],
    angles: [Angle] = [
      .degrees(-25),
      .degrees(25),
      .degrees(-40),
      .degrees(40)
    ]
  ) {
    self._isVisible = isVisible
    self._isAnimationEnabled = isAnimationEnabled
    self.colors = colors
    self.angles = angles
  }

  public var body: some View {
    guard isVisible else {
      return AnyView(EmptyView())
    }

    let animation: Animation? = isAnimationEnabled ?
      Animation.easeInOut(duration: 0.5).delay(0.3).repeatForever(autoreverses: true) :
      .none

    return AnyView(
      ZStack {
        petal

        ForEach(angles, id: \.self) { angle in
          petal
            .rotationEffect(nextAngle(from: angle), anchor: .bottom)
            .animation(animation)
        }
      }
      .if(isAnimationEnabled) {
        $0.onAppear {
          isAnimating.toggle()
        }
      }
    )
  }

  func nextAngle(from angle: Angle) -> Angle {
    if isAnimating {
      return angle
    }

    if angle.degrees > 0 {
      return .degrees(angle.degrees - 10)
    }

    return .degrees(angle.degrees + 10)
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
      FlowerView(isVisible: .constant(false))
        .frame(width: 140, height: 140)
        .colorScheme(.dark)

      FlowerView(isVisible: .constant(false))
        .frame(width: 30, height: 30)
        .colorScheme(.light)
    }
  }
}
#endif
