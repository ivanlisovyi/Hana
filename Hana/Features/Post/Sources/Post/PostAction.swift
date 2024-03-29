//
//  PostAction.swift
//  
//
//  Created by Ivan Lisovyi on 23.12.20.
//

import Foundation

public enum PostAction: Equatable {
  case onAppear(id: Int)
  case favorite(FavoriteAction)
}
