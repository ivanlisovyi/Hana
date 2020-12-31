//
//  PostsEnvironment.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import ComposableArchitecture

import Kaori
import Kitsu
import Keychain

public struct PostsEnvironment {
  public var apiClient: Kaori
  public var imagePreheater: ImagePrefetcher
  public var mainQueue: AnySchedulerOf<DispatchQueue>

  public init(
    apiClient: Kaori,
    imagePreheater: ImagePrefetcher,
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.apiClient = apiClient
    self.imagePreheater = imagePreheater
    self.mainQueue = mainQueue
  }
}
