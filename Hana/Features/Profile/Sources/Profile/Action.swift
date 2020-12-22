//
//  Action.swift
//  
//
//  Created by Ivan Lisovyi on 21.12.20.
//

import Foundation

import Login

public enum ProfileAction: Equatable {
  case logoutButtonTapped
  case logout
  case login(LoginAction)
}
