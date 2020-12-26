//
//  Navigation.swift
//  
//
//  Created by Ivan Lisovyi on 24.12.20.
//

import SwiftUI

public struct Navigation<Leading: View, Trailing: View, Content: View>: View {
  private let leading: () -> Leading
  private let trailing: () -> Trailing
  private let content: () -> Content

  public init(
    @ViewBuilder leading: @escaping () -> Leading,
    @ViewBuilder trailing: @escaping () -> Trailing,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.leading = leading
    self.trailing = trailing
    self.content = content
  }

  public var body: some View {
    GeometryReader { geometry in
      VStack {
        navigationView(geometry: geometry)
        content()
      }
    }
  }

  private func navigationView(geometry: GeometryProxy) -> some View {
    VStack(spacing: 0) {
      Spacer()

      HStack {
        leading()
          .padding(.leading, 16)
        Spacer()
        trailing()
          .padding(.trailing, 16)
      }
      .padding(
        EdgeInsets(
          top: 10,
          leading: geometry.safeAreaInsets.leading,
          bottom: 10,
          trailing: geometry.safeAreaInsets.trailing
        )
      )
    }
    .edgesIgnoringSafeArea([.leading, .top, .trailing])
    .clipped()
    .frame(height: 60)
  }
}

#if DEBUG
struct NavigationView_Previews: PreviewProvider {
  static var previews: some View {
    let navigation = Navigation(
      leading: {
        FlowerView()
          .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
      },
      trailing: {
        Button(
          action: {},
          label: {
            Image(systemName: "person.crop.circle")
              .font(.title)
          }
        )
      },
      content: {
        Text("Content")
      }
    )

    return Group {
      navigation
      .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
      .environment(\.colorScheme, .light)
      navigation
        .previewDevice(PreviewDevice(rawValue: "iPhone X"))
        .environment(\.colorScheme, .light)
    }
  }
}
#endif