//
//  UnstyledButtonStyle.swift
//  
//
//  Created by Ivan Lisovyi on 01.01.21.
//

import SwiftUI

public struct UnstyledButtonStyle: ButtonStyle {
  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
  }
}
