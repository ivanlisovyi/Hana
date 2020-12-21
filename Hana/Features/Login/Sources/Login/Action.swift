//
//  Action.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import Foundation

import Kaori

public enum LoginAction: Equatable {
  case loginButtonTapped
  case loginResponse(Result<Profile, KaoriError>)

  case formUsernameChanged(String)
  case formPasswordChanged(String)

  case alertDismissed
}
