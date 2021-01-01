//
//  NavigationBarModifier.swift
//  
//
//  Created by Ivan Lisovyi on 01.01.21.
//

import SwiftUI

public struct NavigationBarModifier: ViewModifier {
  let backgroundColor: Color

  public init(backgroundColor: Color) {
    self.backgroundColor = backgroundColor

    let coloredAppearance = UINavigationBarAppearance()
    coloredAppearance.configureWithTransparentBackground()
    coloredAppearance.backgroundColor = .clear
    coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

    UINavigationBar.appearance().standardAppearance = coloredAppearance
    UINavigationBar.appearance().compactAppearance = coloredAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    UINavigationBar.appearance().tintColor = .white
  }

  public func body(content: Content) -> some View {
    ZStack{
      content
      VStack {
        GeometryReader { geometry in
          backgroundColor
            .frame(height: geometry.safeAreaInsets.top)
            .edgesIgnoringSafeArea(.top)
          Spacer()
        }
      }
    }
  }
}


public extension View {
  func navigationBarColor(_ backgroundColor: Color) -> some View {
    self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
  }
}
