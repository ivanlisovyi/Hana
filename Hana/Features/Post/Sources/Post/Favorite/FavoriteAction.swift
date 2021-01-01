//
//  FavoriteAction.swift
//  
//
//  Created by Ivan Lisovyi on 23.12.20.
//

import Foundation

public enum FavoriteAction: Equatable {
  case favoriteTapped
  case favoriteResponse(Result<Bool, FavoriteError>)
}

public struct FavoriteError: LocalizedError, Equatable, Identifiable {
  public let underlayingError: Error

  public var id: String {
    underlayingError.localizedDescription
  }

  public var errorDescription: String? {
    underlayingError.localizedDescription
  }

  public static func ==(lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }
}
