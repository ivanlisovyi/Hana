//
//  NavigationBar.swift
//  
//
//  Created by Ivan Lisovyi on 24.12.20.
//

import SwiftUI

public struct NavigationBar<Leading: View, Trailing: View>: View {
  private let leading: () -> Leading
  private let trailing: () -> Trailing

  public init(
    @ViewBuilder leading: @escaping () -> Leading,
    @ViewBuilder trailing: @escaping () -> Trailing
  ) {
    self.leading = leading
    self.trailing = trailing
  }

  public var body: some View {
    HStack {
      leading()
      Spacer()
      trailing()
    }
    .padding()
  }
}

extension NavigationBar where Trailing == EmptyView {
  public init(@ViewBuilder leading: @escaping () -> Leading) {
    self.leading = leading
    self.trailing = { EmptyView() }
  }
}

#if DEBUG
struct NavigationView_Previews: PreviewProvider {
  static var previews: some View {
    let topBar = NavigationBar(
      leading: {
        FlowerView()
          .frame(width: 30, height: 30)
      },
      trailing: {
        Button(
          action: {},
          label: {
            Image(systemName: "person.crop.circle")
              .font(.title)
          }
        )
      }
    )

    return Group {
      topBar.environment(\.colorScheme, .light)
      topBar.environment(\.colorScheme, .dark)
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
