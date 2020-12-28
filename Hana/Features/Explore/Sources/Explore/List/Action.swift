//
//  Action.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import Foundation

public enum ExploreAction: Equatable {
  case post(index: Int, action: PostAction)
  case pagination(PaginationAction<PostState>)
}
