//
//  KaoriLive.swift
//  
//
//  Created by Ivan Lisovyi on 05.12.20.
//

import Foundation
import Kaori

import Amber
import Ning

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

public extension Kaori {
  static func live(environment: Environment = .production) -> Self {
    let session = Session(baseURL: environment.baseURL)

    return Self(
      authenticate: { request in
        session.register(AuthenticationAdapter(username: request.username, apiKey: request.apiKey))

        return session.request(.profile(), decoder: decoder)
      },
      profile: {
        session.request(.profile(), decoder: decoder)
      },
      posts: {
        session.request(.posts(page: $0), decoder: decoder, of: CompactDecodableArray<Post>.self)
          .map(\.elements)
          .eraseToAnyPublisher()
      }
    )
  }

  static let decoder: JSONDecoder = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = .autoupdatingCurrent
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()
}
