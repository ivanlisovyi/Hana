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
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()

  public convenience init(environment: Environment = .production) {
    let session = Session(baseURL: environment.baseURL)
    self.init(session: session)
  }

  init(session: SessionProtocol) {
    self.session = session
  }

  open func authenticate(username: String, apiKey: String) -> AnyPublisher<Void, Error> {
    session.request(.authenticate(username: username, apiKey: apiKey))
  }

  open func posts() -> AnyPublisher<[Post], Error> {
    session.request(.posts(), decoder: decoder)
  }
}
