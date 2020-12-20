//
//  Environment.swift
//  
//
//  Created by Ivan Lisovyi on 20.12.20.
//

import ComposableArchitecture
import Kaori

public struct ExploreEnvironment {
  public var apiClient: Kaori
  public var mainQueue: AnySchedulerOf<DispatchQueue>

  public init(
    apiClient: Kaori,
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.apiClient = apiClient
    self.mainQueue = mainQueue
  }
}
