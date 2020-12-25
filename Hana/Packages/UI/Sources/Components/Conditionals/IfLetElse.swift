//
//  IfElse.swift
//  
//
//  Created by Ivan Lisovyi on 22.12.20.
//

import SwiftUI

public struct IfLetElse<Value, TrueContent: View, FalseContent: View>: View {
  private let value: Value?
  private let trueContent: (Value) -> TrueContent
  private let falseContent: () -> FalseContent
  
  public init(
    _ value: Value?,
    @ViewBuilder trueContent: @escaping (Value) -> TrueContent,
    @ViewBuilder falseContent: @escaping () -> FalseContent
  ) {
    self.value = value
    self.trueContent = trueContent
    self.falseContent = falseContent
  }
  
  public var body: some View {
    if let value = value {
      return AnyView(trueContent(value))
    }

    return AnyView(falseContent())
  }
}

#if DEBUG
struct IfLetElse_Previews: PreviewProvider {
  static var previews: some View {
    let optionalString: String? = "value"

    return IfLetElse(optionalString) { _ in
      Text("✅")
    } falseContent: {
      Text("❌")
    }
  }
}
#endif
