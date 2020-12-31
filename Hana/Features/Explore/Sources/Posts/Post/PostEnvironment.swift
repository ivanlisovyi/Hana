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
}
