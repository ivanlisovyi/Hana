//
//  PostItemEnvironment.swift
//  
//
//  Created by Ivan Lisovyi on 23.12.20.
//

import Foundation
import ComposableArchitecture

public struct PostItemEnvironment {
  public var favorite: (PostItemState.ID, Bool) -> Effect<Bool, Error>
  public var mainQueue: AnySchedulerOf<DispatchQueue>
}
