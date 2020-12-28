//
//  Environment.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import ComposableArchitecture

import Kaori
import Kitsu
import Keychain

public struct ExploreEnvironment {
  public var apiClient: Kaori
  public var imagePreheater: ImagePreheater
  public var mainQueue: AnySchedulerOf<DispatchQueue>

  public init(
    apiClient: Kaori,
    imagePreheater: ImagePreheater,
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.apiClient = apiClient
    self.imagePreheater = imagePreheater
    self.mainQueue = mainQueue
  }
}
