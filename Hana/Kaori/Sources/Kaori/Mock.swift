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
    login: @escaping (Authentication) -> Void = { _ in
      _unimplemented("login")
    },
    logout: @escaping () -> Void = {
      _unimplemented("logout")
    },
    profile: @escaping () -> AnyPublisher<Profile, KaoriError> = {
      _unimplemented("profile")
    },
    posts: @escaping (Int) -> AnyPublisher<[Post], KaoriError> = { _ in
      _unimplemented("posts")
    },
    favorite: @escaping (Int) -> AnyPublisher<Post, KaoriError> = { _ in
      _unimplemented("favorite")
    },
    unfavorite: @escaping (Int) -> AnyPublisher<Void, KaoriError> = { _ in
      _unimplemented("unfavorite")
    }
  ) -> Self {
    Self(
      login: login,
      logout: logout,
      profile: profile,
      posts: posts,
      favorite: favorite,
      unfavorite: unfavorite
    )
  }

  static func decodeMock<T: Decodable>(
    of type: T.Type,
    for resource: String,
    in bundle: Bundle = .main
  ) throws -> T {
    guard let json = bundle.url(forResource: resource, withExtension: nil),
          let data = try? Data(contentsOf: json) else {
      throw KaoriError.decoding("Failed to load json data for resource \(resource) of \(type) type in \(bundle) bundle")
    }

    let dateFormatter = DateFormatter()
    dateFormatter.locale = .autoupdatingCurrent
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    guard let result = try? decoder.decode(T.self, from: data) else {
      throw KaoriError.decoding("Failed to load json data for resource \(resource) of \(type) type in \(bundle) bundle")
    }

    return result
  }

  static func decodeMockPublisher<T: Decodable>(
    of type: T.Type,
    for resource: String,
    in bundle: Bundle = .main
  ) -> AnyPublisher<T, KaoriError> {
    do {
      return Just(try decodeMock(of: type, for: resource, in: bundle))
        .setFailureType(to: KaoriError.self)
        .eraseToAnyPublisher()
    } catch {
      return Fail(error: error)
        .mapError { _ in KaoriError.decoding(error.localizedDescription)}
        .eraseToAnyPublisher()
    }
  }
}

public func _unimplemented(
  _ function: StaticString, file: StaticString = #file, line: UInt = #line
) -> Never {
  fatalError(
    """
    `\(function)` was called but is not implemented. Be sure to provide an implementation for
    this endpoint when creating the mock.
    """,
    file: file,
    line: line
  )
}
