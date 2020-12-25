//
//  View+Erasure.swift
//  
//
//  Created by Ivan Lisovyi on 22.12.20.
//

import SwiftUI

public extension View {
  func eraseToAnyView() -> AnyView {
    AnyView(self)
  }
}
