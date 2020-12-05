//
//  Kaori.swift
//  
//
//  Created by Lisovyi, Ivan on 01.12.20.
//

import Foundation
import Ning

open class Kaori {
  public enum Environment {
    case development
    case production

    public var baseURL: URL {
      switch self {
      case .development:
        return URL(staticString: "https://testbooru.donmai.us/")
      case .production:
        return URL(staticString: "https://danbooru.donmai.us/")
      }
    }
  }

  private let session: SessionProtocol

  private lazy var decoder: JSONDecoder = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = .autoupdatingCurrent
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()

  public convenience init(environment: Environment = .production) {
    self.init(session: Session(baseURL: environment.baseURL))
  }

  init(session: SessionProtocol) {
    self.session = session
  }

  /// Authenticates user with **Danbooru** backend and fetches user profile.
  ///
  /// - Note: The authentication is valid for the lifetime of the session.
  ///
  /// - Parameter username: The username of the user to be authenticated.
  /// - Parameter apiKey: The api key used for the authentication.
  ///
  /// - Returns: A publisher with either users `Profile` or `SessionError`.
  open func authenticate(username: String, apiKey: String) -> AnyPublisher<Profile, Error> {
    session.register(AuthenticationAdapter(username: username, apiKey: apiKey))

    return profile()
  }

  /// Requests current authenticated user profile.
  ///
  /// - Note: If `authenticate` has not been called before this method will fail with `SessionError.network` error.
  ///
  /// - Returns: A publisher with either users `Profile` or `SessionError`.
  open func profile() -> AnyPublisher<Profile, Error> {
    session.request(.profile(), decoder: decoder)
  }

  open func posts() -> AnyPublisher<[Post], Error> {
    session.request(.posts(), decoder: decoder)
  }
}
