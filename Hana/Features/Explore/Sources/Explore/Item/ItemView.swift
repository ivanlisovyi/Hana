//
//  ItemView.swift
//  
//
//  Created by Ivan Lisovyi on 13.12.20.
//

import SwiftUI

import Kaori
import WebImage

import ViewModifiers

struct ItemView: View {
  private var image: Post.Image

  init(image: Post.Image) {
    self.image = image
  }

  var body: some View {
    WebImage(url: image.url)
      .resized(width: 300)
      .frame(minHeight: (CGFloat(300) / CGFloat(image.width)) * CGFloat(image.height))
      .clipped()
      .clipShape(RoundedRectangle.init(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
  }
}

extension View {
  func nsfw() -> some View {
    modifier(NSFW())
  }
}
