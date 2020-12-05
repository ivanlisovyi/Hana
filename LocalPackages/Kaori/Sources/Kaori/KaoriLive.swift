//
//  KaoriLive.swift
//  
//
//  Created by Ivan Lisovyi on 05.12.20.
//

import ComposableArchitecture
import Ning
import Coil

public extension Kaori {
  static let live = Kaori(
    authenticate: { request in
      session.register(AuthenticationAdapter(username: request.username, apiKey: request.apiKey))

      return session
        .request(.profile(), decoder: decoder)
        .eraseToEffect()
    },
    profile: {
      session
        .request(.profile(), decoder: decoder)
        .eraseToEffect()
    },
    posts: {
      session
        .request(.posts(), decoder: decoder)
        .eraseToEffect()
    }
  )

  private static var session: SessionProtocol { Injected(resolver: resolver).wrappedValue }
  private static var decoder: JSONDecoder { Injected(resolver: resolver).wrappedValue }
}

public let resolver = Container {
  Dependency { _ -> SessionProtocol in
    Session(baseURL: Environment.production.baseURL)
  }
  Dependency { _ -> JSONDecoder in
    let dateFormatter = DateFormatter()
    dateFormatter.locale = .autoupdatingCurrent
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }
}

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
