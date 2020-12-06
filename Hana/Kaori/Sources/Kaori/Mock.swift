//
//  KaoriMock.swift
//  
//
//  Created by Ivan Lisovyi on 05.12.20.
//

import Combine

public extension Kaori {
  static func mock(
    authenticate: @escaping (Authentication) -> AnyPublisher<Profile, Error> = { _ in
      _unimplemented("authenticate")
    },
    profile: @escaping () -> AnyPublisher<Profile, Error> = {
      _unimplemented("profile")
    },
    posts: @escaping (Int) -> AnyPublisher<[Post], Error> = { _ in
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
