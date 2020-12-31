//
//  Geometry+Ext.swift
//  
//
//  Created by Ivan Lisovyi on 31.12.20.
//

import SwiftUI

public extension GeometryProxy {
  var aspectRatio: CGFloat {
    size.width / size.height
  }
}
