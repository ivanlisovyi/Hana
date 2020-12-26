//
//  State.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import Foundation
import Common

import Kaori
import Login
import Profile

public struct ExploreState: Equatable {
  public var isSheetPresented: Bool

  public var pagination: PaginationState<PostState>
  public var profile: ProfileState

  public var keychain: KeychainState {
    get { .init(credentials: .init(username: profile.username, password: profile.password)) }
    set {
      if let newCredentials = newValue.credentials {
        (profile.username, profile.password) = (newCredentials.username, newCredentials.password)
      }
    }
  }

  public init(
    isSheetPresented: Bool = false,
    pagination: PaginationState<PostState> = .init(),
    profile: ProfileState = .init()
  ) {
    self.isSheetPresented = isSheetPresented
    self.pagination = pagination
    self.profile = profile
  }
}
