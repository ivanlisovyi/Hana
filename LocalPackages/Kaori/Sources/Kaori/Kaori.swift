//
//  Kaori.swift
//  
//
//  Created by Lisovyi, Ivan on 01.12.20.
//

import ComposableArchitecture
import Ning

public struct AuthenticationRequest: Equatable {
  let username: String
  let apiKey: String
}

public struct Kaori {
  public var authenticate: (AuthenticationRequest) -> Effect<Profile, Error>
  public var profile: () -> Effect<Profile, Error>
  public var posts: () -> Effect<[Post], Error>

  public init(
    authenticate: @escaping (AuthenticationRequest) -> Effect<Profile, Error>,
    profile:  @escaping () -> Effect<Profile, Error>,
    posts:  @escaping () -> Effect<[Post], Error>
  ) {
    self.authenticate = authenticate
    self.profile = profile
    self.posts = posts
  }
}
