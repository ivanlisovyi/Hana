//
//  IfLet.swift
//  
//
//  Created by Ivan Lisovyi on 22.12.20.
//

import SwiftUI

public struct IfLet<Value, Content: View>: View {
  private let value: Value?
  private let content: (Value) -> Content

  public init(
    _ value: Value?,
    @ViewBuilder content: @escaping (Value) -> Content
  ) {
    self.value = value
    self.content = content
  }

  public var body: some View {
    value.map(content)
  }
}

#if DEBUG
struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    let optionalString: String? = "value"

    return IfLet(optionalString) { _ in
      Text("✅")
    }
  }
}
#endif
