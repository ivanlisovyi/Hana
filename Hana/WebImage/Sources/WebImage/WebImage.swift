//
//  WebImage.swift
//
//
//  Created by Ivan Lisovyi on 06.12.20.
//

import SwiftUI
import FetchImage

public struct WebImage: View {
  @ObservedObject var image: FetchImage

  public init(url: URL) {
    image = FetchImage(url: url)
  }

  public var body: some View {
      ZStack {
          Rectangle().fill(Color.gray)
          image.view?
              .resizable()
              .aspectRatio(contentMode: .fill)
      }
      .animation(.default)
      .onAppear(perform: image.fetch)
      .onDisappear(perform: image.cancel)
  }
}

#if DEBUG
struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        let url = URL(string: "https://cloud.githubusercontent.com/assets/1567433/9781817/ecb16e82-57a0-11e5-9b43-6b4f52659997.jpg")!
      return WebImage(url: url)
            .frame(width: 80, height: 80)
            .clipped()
    }
}
#endif
