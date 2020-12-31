//
//  FavoriteState.swift
//  
//
//  Created by Ivan Lisovyi on 23.12.20.
//

import Foundation

public struct FavoriteState<ID>: Equatable, Identifiable where ID: Hashable {
  public let id: ID
  public var isFavorite: Bool
}
