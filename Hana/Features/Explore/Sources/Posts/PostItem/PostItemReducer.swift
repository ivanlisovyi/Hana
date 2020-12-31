//
//  PostItemReducer.swift
//  
//
//  Created by Ivan Lisovyi on 23.12.20.
//

import Foundation
import ComposableArchitecture

public let postItemReducer = Reducer<PostItemState, PostItemAction, PostItemEnvironment>.empty.favorite(
  state: \.favorite,
  action: /PostItemAction.favorite,
  environment: { FavoriteEnvironment(request: $0.favorite, mainQueue: $0.mainQueue) }
)
