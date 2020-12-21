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
  var profile: Profile

  public subscript<T>(dynamicMember keyPath: KeyPath<Profile, T>) -> T {
    profile[keyPath: keyPath]
  }
}
