//
//  PostEnvironment.swift
//  
//
//  Created by Ivan Lisovyi on 23.12.20.
//

import Foundation
import ComposableArchitecture

public struct PostEnvironment {
  public var favorite: (PostState.ID, Bool) -> Effect<Bool, Error>
  public var mainQueue: AnySchedulerOf<DispatchQueue>

  public init(
    favorite: @escaping (PostState.ID, Bool) -> Effect<Bool, Error>,
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.favorite = favorite
    self.mainQueue = mainQueue
  }
}
