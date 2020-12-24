//
//  Environment.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import ComposableArchitecture
import Kaori
import Keychain

public struct ExploreEnvironment {
  public var apiClient: Kaori
  public var keychain: Keychain
  public var mainQueue: AnySchedulerOf<DispatchQueue>

  public init(
    apiClient: Kaori,
    keychain: Keychain,
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.apiClient = apiClient
    self.keychain = keychain
    self.mainQueue = mainQueue
  }
}
