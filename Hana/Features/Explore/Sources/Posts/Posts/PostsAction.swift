//
//  PostsAction.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import Foundation
import CoreGraphics

public enum PostsAction: Equatable {
  case itemSizeChanged(Int)
  case post(index: Int, action: PostAction)
  case magnification(MagnificationAction)
  case pagination(PaginationAction<PostState>)
}
