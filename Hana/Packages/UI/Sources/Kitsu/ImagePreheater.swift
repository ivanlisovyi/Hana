//
//  ImagePreheater.swift
//  
//
//  Created by Ivan Lisovyi on 27.12.20.
//

import Foundation
import Nuke

public struct ImagePreheater {
  public let start: ([URL]) -> Void
  public let stop: ([URL]) -> Void

  public init(
    start: @escaping ([URL]) -> Void,
    stop: @escaping ([URL]) -> Void
  ) {
    self.start = start
    self.stop = stop
  }
}

public extension ImagePreheater {
  static func live() -> Self {
    let preheater = Nuke.ImagePreheater(destination: .diskCache)

    return Self(
      start: preheater.startPreheating(with:),
      stop: preheater.stopPreheating(with:)
    )
  }
}
