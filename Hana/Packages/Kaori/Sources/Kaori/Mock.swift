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
}

public enum KaoriMocks {
  public enum JSON: String, Equatable {
    case posts
    case profile

    public var url: URL? {
      Bundle.module.url(forResource: self.rawValue, withExtension: "json")
    }
  }

  public static func decode<T: Decodable>(
    _ type: T.Type,
    from asset: JSON
  ) throws -> T {
    guard let url = asset.url else {
      throw KaoriError.decoding("Failed to load json data for asset \(asset.rawValue) of \(type)")
    }

    return try decode(type, from: url)
  }

  public static func decode<T: Decodable>(
    _ type: T.Type,
    from resource: String,
    in bundle: Bundle = .main
  ) throws -> T {
    guard let url = bundle.url(forResource: resource, withExtension: nil) else {
      throw KaoriError.decoding("Failed to load json data for resource \(resource) of \(type) type in \(bundle) bundle")
    }

    return try decode(type, from: url)
  }

  public static func decode<T: Decodable>(
    _ type: T.Type,
    from url: URL
  ) throws -> T {
    guard let data = try? Data(contentsOf: url) else {
      throw KaoriError.decoding("Failed to load json data for resource at \(url) of \(type) type")
    }

    let dateFormatter = DateFormatter()
    dateFormatter.locale = .autoupdatingCurrent
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    guard let result = try? decoder.decode(T.self, from: data) else {
      throw KaoriError.decoding("Failed to load json data for resource \(url) of \(type) type")
    }

    return result
  }

  public static func decodePublisher<T: Decodable>(
    _ type: T.Type,
    from asset: JSON
  ) -> AnyPublisher<T, KaoriError> {
    Result {
      try decode(type, from: asset)
    }
    .publisher
    .mapError { KaoriError.decoding($0.localizedDescription) }
    .eraseToAnyPublisher()
  }

  public static func decodePublisher<T: Decodable>(
    _ type: T.Type,
    for resource: String,
    in bundle: Bundle = .main
  ) -> AnyPublisher<T, KaoriError> {
    Result {
      try decode(type, from: resource, in: bundle)
    }
    .publisher
    .mapError { KaoriError.decoding($0.localizedDescription) }
    .eraseToAnyPublisher()
  }

  public class BundleFinder {}
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
