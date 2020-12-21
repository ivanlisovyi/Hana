//
//  ProfileEnvironment.swift
//  
//
//  Created by Ivan Lisovyi on 21.12.20.
//

import Foundation

import ComposableArchitecture
import Kaori

public struct ProfileEnvironment {
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
