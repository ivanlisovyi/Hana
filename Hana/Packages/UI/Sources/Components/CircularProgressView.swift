//
//  CircularProgressView.swift
//  
//
//  Created by Ivan Lisovyi on 01.01.21.
//

import SwiftUI

public struct CircularProgressView: View {
  private let value: Double

  public init(value: Double) {
    self.value = value
  }

  public var body: some View {
    Circle()
      .trim(from: 0, to: CGFloat(value))
      .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
      .foregroundColor(Color.darkPink)
      .rotationEffect(Angle(degrees: -90))
      .animation(.easeIn)
  }
}

#if DEBUG
struct CircularProgressView_Previews: PreviewProvider {
  static var previews: some View {
    CircularProgressView(value: 0.3).frame(width: 44, height: 44)
  }
}
#endif
