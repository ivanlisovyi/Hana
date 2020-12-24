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

public enum ExploreAction {
  case onAppear

  case fetch
  case fetchNext(after: PostState)
  case fetchResponse(Result<[PostState], KaoriError>)

  case setSheet(isPresented: Bool)

  case post(index: Int, action: PostAction)

  case profile(ProfileAction)
  case keychain(KeychainAction)
}
