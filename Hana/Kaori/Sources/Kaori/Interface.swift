//
//  Kaori.swift
//  
//
//  Created by Lisovyi, Ivan on 01.12.20.
//

import Foundation
import Combine

public struct Kaori {
  public enum KaoriError: LocalizedError, Equatable {
    case network
    case decoding
    case unknown
  }

  public var authenticate: (Authentication) -> AnyPublisher<Profile, KaoriError>
  public var profile: () -> AnyPublisher<Profile, KaoriError>
  public var posts: (Int) -> AnyPublisher<[Post], KaoriError>

  public init(
    authenticate: @escaping (Authentication) -> AnyPublisher<Profile, KaoriError>,
    profile:  @escaping () -> AnyPublisher<Profile, KaoriError>,
    posts:  @escaping (Int) -> AnyPublisher<[Post], KaoriError>
  ) {
    self.authenticate = authenticate
    self.profile = profile
    self.posts = posts
  }
}
