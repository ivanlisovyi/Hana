//
//  State.swift
//
//
//  Created by Ivan Lisovyi on 21.12.20.
//

import ComposableArchitecture
import Kaori

@dynamicMemberLookup
public struct ProfileState: Equatable {
  public var profile: Profile

  public init(profile: Profile) {
    self.profile = profile
  }

  public subscript<T>(dynamicMember keyPath: KeyPath<Profile, T>) -> T {
    profile[keyPath: keyPath]
  }
}
