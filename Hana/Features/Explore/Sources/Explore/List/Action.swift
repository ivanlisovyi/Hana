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
  case onAppear

  case credentials(Result<Keychain.Credentials, KeychainError>)

  case fetch
  case fetchNext(after: PostState)
  case fetchResponse(Result<[PostState], KaoriError>)

  case post(index: Int, action: PostAction)

  case setSheet(isPresented: Bool)
  case profile(ProfileAction)
}
