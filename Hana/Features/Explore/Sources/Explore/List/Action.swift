//
//  Action.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import Foundation
import CoreGraphics

public enum ExploreAction: Equatable {
  case scaleChanged(CGFloat)
  case sizeChanged(Int)
  case post(index: Int, action: PostAction)
  case pagination(PaginationAction<PostState>)
}
