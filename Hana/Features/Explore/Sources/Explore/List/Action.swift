//
//  Action.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import Foundation

import Kaori
import Profile

public enum ExploreAction: Equatable {
  case fetch
  case fetchNext(after: Post)
  case fetchResponse(Result<[Post], KaoriError>)

  case setSheet(isPresented: Bool)
  case profile(ProfileAction)
}
