//
//  KaoriMock.swift
//  
//
//  Created by Ivan Lisovyi on 05.12.20.
//

import Foundation
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

  static func decodeMock<T: Decodable>(
    of type: T.Type,
    for resource: String,
    in bundle: Bundle = .main
  ) -> AnyPublisher<T, KaoriError> {
    guard let json = bundle.url(forResource: resource, withExtension: nil),
          let data = try? Data(contentsOf: json) else {
      return Fail(error: Kaori.KaoriError.network)
        .eraseToAnyPublisher()
    }

    let dateFormatter = DateFormatter()
    dateFormatter.locale = .autoupdatingCurrent
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    guard let result = try? decoder.decode(T.self, from: data) else {
      return Fail(error: Kaori.KaoriError.decoding)
        .eraseToAnyPublisher()
    }

    return Just(result)
      .setFailureType(to: KaoriError.self)
      .eraseToAnyPublisher()
  }
}
