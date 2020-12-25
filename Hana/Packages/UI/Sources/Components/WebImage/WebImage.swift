//
//  WebImage.swift
//
//
//  Created by Ivan Lisovyi on 06.12.20.
//

import SwiftUI

import FetchImage
import Nuke

public struct WebImage: View {
  @ObservedObject var image: FetchImage

  public init(url: URL) {
    self.init(request: ImageRequest(url: url))
  }

  init(request: ImageRequest) {
    image = FetchImage(request: request)
  }

  public var body: some View {
    ZStack {
      Rectangle().fill(Color(.secondarySystemBackground))
      image.view?
        .resizable()
        .scaledToFill()
        .transition(AnyTransition.opacity.animation(Animation.default))
    }
    .compositingGroup()
    .onAppear(perform: image.fetch)
    .onDisappear(perform: image.cancel)
  }
}

public extension WebImage {
  typealias Unit = ImageProcessingOptions.Unit
  typealias Border = ImageProcessingOptions.Border
  typealias ContentMode = ImageProcessors.Resize.ContentMode

  fileprivate func configure(_ block: @autoclosure () -> ImageProcessing) -> WebImage {
    var result = self.image.request
    result.processors.append(block())
    return WebImage(request: result)
  }

  /// Resizes the image to the given width preserving aspect ratio.
  ///
  /// - Parameters:
  ///   - width: The target width.
  ///   - height: The target height.
  ///   - unit: Unit of the target size, `.points` by default.
  ///   - contentMode: `.aspectFill` by default.
  ///   - crop: If `true` will crop the image to match the target size.
  ///           Does nothing with content mode .aspectFill. `false` by default.
  ///   - upscale: `false` by default.
  func resized(
    width: CGFloat = 4096,
    height: CGFloat = 4096,
    unit: ImageProcessingOptions.Unit = .points,
    contentMode: ContentMode = .aspectFill,
    crop: Bool = false,
    upscale: Bool = false
  ) -> Self {
    configure(
      ImageProcessors.Resize(
        size: CGSize(width: width, height: height),
        unit: unit,
        contentMode: contentMode,
        crop: crop,
        upscale: upscale
      )
    )
  }

  /// Rounds the corners of an image to the specified radius.
  ///
  /// - Warning: In order for the corners to be displayed correctly,
  ///            the image must exactly match the size of the image view in which it will be displayed.
  ///            See `resized(width:height:unit:contentMode:crop:upscale)` for more info.
  ///
  /// - Parameters:
  ///   - radius: The radius of the corners.
  ///   - unit: Unit of the radius, `.points` by default.
  ///   - border: An optional border drawn around the image.
  func roundedCorners(
    radius: CGFloat,
    unit: Unit = .points,
    border: Border? = nil
  ) -> Self {
    configure(
      ImageProcessors.RoundedCorners(
        radius: radius,
        unit: unit,
        border: border
      )
    )
  }
}

#if DEBUG
struct ImageView_Previews: PreviewProvider {
  static var previews: some View {
    let url = URL(string: "https://danbooru.donmai.us/data/sample/__original_drawn_by_seelean__sample-55e62175a58a9f7b46a6461ca1111540.jpg")!
    return WebImage(url: url)
      .resized(width: 300, height: 300)
      .clipped()
  }
}
#endif
