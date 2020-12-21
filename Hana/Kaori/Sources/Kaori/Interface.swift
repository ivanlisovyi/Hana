//
//  Kaori.swift
//  
//
//  Created by Lisovyi, Ivan on 01.12.20.
//

import Foundation
import Combine

public struct Kaori {
  public let authenticate: (Authentication) -> Void
  public let profile: () -> AnyPublisher<Profile, KaoriError>
  public let posts: (Int) -> AnyPublisher<[Post], KaoriError>

  public init(
    authenticate: @escaping (Authentication) -> Void,
    profile:  @escaping () -> AnyPublisher<Profile, KaoriError>,
    posts:  @escaping (Int) -> AnyPublisher<[Post], KaoriError>
  ) {
    self.authenticate = authenticate
    self.profile = profile
    self.posts = posts
  }
}
