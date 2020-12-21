//
//  Action.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import Foundation

import Login
import Kaori

public enum ExploreAction: Equatable {
  case fetch
  case fetchNext(after: Post)
  case fetchResponse(Result<[Post], KaoriError>)

  case setLoginSheet(isPresented: Bool)
  case login(LoginAction)
}
