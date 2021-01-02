//
//  Colors.swift
//  
//
//  Created by Ivan Lisovyi on 26.12.20.
//

import SwiftUI

public extension Color {
  static let flamenco = Color(#colorLiteral(red: 0.9176470588, green: 0.5607843137, blue: 0.337254902, alpha: 1))
  static let darkPink = Color(#colorLiteral(red: 0.9254901961, green: 0.3411764706, blue: 0.5490196078, alpha: 1))

  static let primaryDark = Color(#colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1))
  static let primaryLight = Color(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1))

  static let secondaryDark = Color(#colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1))
  static let secondaryLight = Color(#colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1))
}

public extension LinearGradient {
  static let primary = LinearGradient(
    gradient: Gradient(colors: [Color.darkPink, Color.flamenco]),
    startPoint: .top,
    endPoint: .bottom
  )
}
