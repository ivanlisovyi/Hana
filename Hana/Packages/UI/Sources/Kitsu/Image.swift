//
//  Image.swift
//
//
//  Created by Ivan Lisovyi on 06.12.20.
//

import SwiftUI

import FetchImage
import Nuke

import DesignSystem
import Components

public struct Image: View {
  @Environment(\.colorScheme) var colorScheme

  @ObservedObject var image: FetchImage

  let aspectRatio: CGFloat?

  public init(url: URL, aspectRatio: CGFloat? = nil) {
    self.init(request: ImageRequest(url: url))
  }

  init(
    request: ImageRequest,
    pipeline: ImagePipeline = Self.defaultPipeline,
    aspectRatio: CGFloat? = nil
  ) {
    self.aspectRatio = aspectRatio

    image = FetchImage(request: request, pipeline: pipeline)
    image.fetch()
  }

  public var body: some View {
    GeometryReader { geometry in
      let flowerSize = max(geometry.size.width, geometry.size.height) * 0.2

      ZStack {
        Rectangle().fill(colorScheme == .dark ? Color.secondaryDark : Color.secondaryLight)
          .overlay(
            FlowerView()
              .frame(width: flowerSize, height: flowerSize)
              .saturation(0.2),
            alignment: .center
          )
          .drawingGroup()

        image.view?
          .resizable()
          .aspectRatio(aspectRatio, contentMode: .fill)
          .frame(height: geometry.size.height, alignment: .top)
          .clipped()
      }
      .frame(height: geometry.size.height)
      .onAppear(perform: image.fetch)
      .onDisappear(perform: image.reset)
    }
  }
}

extension Image {
  static let defaultPipeline = ImagePipeline {
    DataLoader.sharedUrlCache.diskCapacity = 0

    $0.dataCache = try? DataCache(name: "com.ivanlisovyi.hana.data.cache")
  }
}

public extension Image {
  typealias Unit = ImageProcessingOptions.Unit
  typealias Border = ImageProcessingOptions.Border
  typealias ContentMode = ImageProcessors.Resize.ContentMode

  fileprivate func configure(_ block: @autoclosure () -> ImageProcessing) -> Image {
    var result = self.image.request
    result.processors.append(block())
    return Image(request: result)
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
  func resize(
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

extension FetchImage {
  var fractionCompleted: Double {
    if progress.total == 0 {
      return 0.01
    }

    return Double(progress.completed) / Double(progress.total)
  }

  var isCompleted: Bool {
    progress.completed == progress.total
  }
}

#if DEBUG
struct ImageView_Previews: PreviewProvider {
  static var previews: some View {
    let url = URL(string: "https://danbooru.donmai.us/data/sample/__original_drawn_by_seelean__sample-55e62175a58a9f7b46a6461ca1111540.jpg")!
    return Image(url: url)
      .resize(width: 300, height: 300)
      .clipped()
  }
}
#endif
