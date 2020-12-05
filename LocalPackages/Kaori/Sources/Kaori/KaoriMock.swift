//
//  KaoriMock.swift
//  
//
//  Created by Ivan Lisovyi on 05.12.20.
//

import ComposableArchitecture
import Ning

public extension Kaori {
  static func mock(
    authenticate: @escaping (AuthenticationRequest) -> Effect<Profile, Error> = { request in
      _unimplemented("authenticate")
    },
    profile: @escaping () -> Effect<Profile, Error> = {
      _unimplemented("profile")
    },
    posts: @escaping () -> Effect<[Post], Error> = {
      _unimplemented("posts")
    }
  ) -> Self {
    Self(
      authenticate: authenticate,
      profile: profile,
      posts: posts
    )
  }
}
