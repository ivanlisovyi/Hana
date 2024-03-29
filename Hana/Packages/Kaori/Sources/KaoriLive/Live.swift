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
      login: { request in
        session.authenticate(user: request.username, password: request.apiKey)
      },
      logout: {
        session.deauthenticate()
      },
      profile: {
        session.request(.profile(), decoder: decoder)
          .mapError(KaoriError.init(underlayingError:))
          .eraseToAnyPublisher()
      },
      posts: { request in
        let posts = session.request(
          .posts(request: request),
          decoder: decoder,
          of: CompactDecodableArray<Post>.self
        )
        .map(\.elements)
        .mapError(KaoriError.init(underlayingError:))

        guard let userId = request.userId else {
          return posts.eraseToAnyPublisher()
        }

        return posts.flatMap { result -> AnyPublisher<[Post], KaoriError> in
          let justPosts = Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

          let ids = result.map(\.id)
          let statuses: AnyPublisher<[FavoriteStatus], Error> = session.request(
            .favoriteStatus(request: .init(ids: ids, userId: userId)),
            decoder: decoder
          )

          return Publishers.Zip(
            justPosts,
            statuses
          )
          .map { (posts, statuses) in
            posts.map { post -> Post in
              var newValue = post
              if statuses.contains(where: { $0.postId == post.id }) {
                newValue.isFavorited = true
              }
              return newValue
            }
          }
          .mapError(KaoriError.init(underlayingError:))
          .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
      },
      favoriteStatus: {
        session.request(.favoriteStatus(request: $0), decoder: decoder)
          .mapError(KaoriError.init(underlayingError:))
          .eraseToAnyPublisher()
      },
      favorite: {
        session.request(.favorite(id: $0), decoder: decoder)
          .mapError(KaoriError.init(underlayingError:))
          .eraseToAnyPublisher()
      },
      unfavorite: { 
        session.request(.unfavorite(id: $0))
          .mapError(KaoriError.init(underlayingError:))
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

extension KaoriError {
  public init(underlayingError: Error) {
    if underlayingError is SessionError {
      self = .network(underlayingError.localizedDescription)
    } else if underlayingError is DecodingError {
      self = .decoding(underlayingError.localizedDescription)
    } else {
      self = .unknown
    }
  }
}
