//
//  Kaori.swift
//  
//
//  Created by Lisovyi, Ivan on 01.12.20.
//

import Combine

public struct Kaori {
  public var authenticate: (Authentication) -> AnyPublisher<Profile, Error>
  public var profile: () -> AnyPublisher<Profile, Error>
  public var posts: (Int) -> AnyPublisher<[Post], Error>

  public init(
    authenticate: @escaping (Authentication) -> AnyPublisher<Profile, Error>,
    profile:  @escaping () -> AnyPublisher<Profile, Error>,
    posts:  @escaping (Int) -> AnyPublisher<[Post], Error>
  ) {
    self.authenticate = authenticate
    self.profile = profile
    self.posts = posts
  }
}
