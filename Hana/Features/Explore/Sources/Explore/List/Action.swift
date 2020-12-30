//
//  Action.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import Foundation
import CoreGraphics

public enum ScaleEvent: Equatable {
  case changed(CGFloat)
  case ended(CGFloat)
}

public enum ExploreAction: Equatable {
  case scale(ScaleEvent)
  case itemSizeChanged(Int)
  case post(index: Int, action: PostAction)
  case pagination(PaginationAction<PostState>)
}
