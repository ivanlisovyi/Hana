//
//  Kaori.swift
//  
//
//  Created by Lisovyi, Ivan on 01.12.20.
//

import Foundation
import Combine

public struct Kaori {
  public let login: (Authentication) -> Void
  public let logout: () -> Void
  public let profile: () -> AnyPublisher<Profile, KaoriError>
  public let posts: (Int) -> AnyPublisher<[Post], KaoriError>
  public let favorite: (Int) -> AnyPublisher<Post, KaoriError>
  public let unfavorite: (Int) -> AnyPublisher<Void, KaoriError>

  public init(
    login: @escaping (Authentication) -> Void,
    logout: @escaping () -> Void,
    profile:  @escaping () -> AnyPublisher<Profile, KaoriError>,
    posts:  @escaping (Int) -> AnyPublisher<[Post], KaoriError>,
    favorite: @escaping (Int) -> AnyPublisher<Post, KaoriError>,
    unfavorite: @escaping (Int) -> AnyPublisher<Void, KaoriError>
  ) {
    self.login = login
    self.logout = logout
    self.profile = profile
    self.posts = posts
    self.favorite = favorite
    self.unfavorite = unfavorite
  }
}
