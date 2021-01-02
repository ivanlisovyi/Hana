//
//  PostsAction.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import Foundation
import CoreGraphics

import Post

public enum PostsAction: Equatable {
  case sizeChanged(Int)
  case post(index: Int, action: PostAction)
  case magnification(MagnificationAction)
  case pagination(PaginationAction<PostState>)
}
