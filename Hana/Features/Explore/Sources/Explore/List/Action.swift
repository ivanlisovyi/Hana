//
//  Action.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import Foundation

import Kaori
import Profile
import Keychain

public enum ExploreAction: Equatable {
  case setSheet(isPresented: Bool)

  case post(index: Int, action: PostAction)
  case pagination(PaginationAction<PostState>)
  case profile(ProfileAction)
  case keychain(KeychainAction)
}
