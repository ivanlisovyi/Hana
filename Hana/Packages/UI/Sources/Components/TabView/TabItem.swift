//
//  TabItem.swift
//
//
//  Created by Ivan Lisovyi on 27.12.20.
//


import SwiftUI

public struct TabItem<V: View> {
  let content: (Bool) -> V

  public init(@ViewBuilder tabView: @escaping (Bool) -> V) {
    self.content = tabView
  }
}
