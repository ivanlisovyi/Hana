//
//  Reducer.swift
//  
//
//  Created by Ivan Lisovyi on 21.12.20.
//

import Foundation

import ComposableArchitecture
import Kaori

public let profileReducer = Reducer<ProfileState, ProfileAction, ProfileEnvironment> {
  state, action, environment in
  switch action {
  case .logoutButtonTapped:
    return .none
  }
}
