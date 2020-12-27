//
//  BottomBarItem.swift
//
//
//  Created by Ivan Lisovyi on 27.12.20.
//


import SwiftUI

public struct BottomBarItem {
  public let icon: Image
  public let text: String
  public let color: Color
  
  public init(
    icon: Image,
    text: String,
    color: Color
  ) {
    self.icon = icon
    self.text = text
    self.color = color
  }

  public init(
    icon systemName: String,
    text: String,
    color: Color
  ) {
    self = BottomBarItem(
      icon: Image(systemName: systemName),
      text: text,
      color: color
    )
  }
}
