//
//  KaoriMock.swift
//  
//
//  Created by Ivan Lisovyi on 05.12.20.
//

import Combine

public extension Kaori {
  static func mock(
    authenticate: @escaping (Authentication) -> AnyPublisher<Profile, KaoriError> = { _ in
      fatalError(
        """
        authenticate was called but is not implemented. Be sure to provide an implementation for
        this endpoint when creating the mock.
        """,
        file: #file,
        line: #line
      )
    },
    profile: @escaping () -> AnyPublisher<Profile, KaoriError> = {
      fatalError(
        """
        profile was called but is not implemented. Be sure to provide an implementation for
        this endpoint when creating the mock.
        """,
        file: #file,
        line: #line
      )
    },
    posts: @escaping (Int) -> AnyPublisher<[Post], KaoriError> = { _ in
      fatalError(
        """
        posts was called but is not implemented. Be sure to provide an implementation for
        this endpoint when creating the mock.
        """,
        file: #file,
        line: #line
      )
    }
  ) -> Self {
    Self(
      authenticate: authenticate,
      profile: profile,
      posts: posts
    )
  }
}
