//
//  PostReducer.swift
//  
//
//  Created by Ivan Lisovyi on 23.12.20.
//

import Foundation
import ComposableArchitecture

public let postReducer = Reducer<PostState, PostAction, PostEnvironment>.empty.favorite(
  state: \.favorite,
  action: /PostAction.favorite,
  environment: { FavoriteEnvironment(request: $0.favorite, mainQueue: $0.mainQueue) }
)
