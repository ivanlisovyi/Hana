//
//  Authentication.swift
//  
//
//  Created by Ivan Lisovyi on 05.12.20.
//

import Foundation
import Combine

import Ning

struct AuthenticationAdapter: RequestAdapter, Hashable {
  let username: String
  let apiKey: String

  init(username: String, apiKey: String) {
    self.username = username
    self.apiKey = apiKey
  }

  func adapt(_ request: URLRequest) -> AnyPublisher<URLRequest, Error> {
    Deferred {
      Future { promise in
        if let url = request.url {
          var components = URLComponents(url: url, resolvingAgainstBaseURL: false)

          var queryItems = components?.queryItems ?? []
          queryItems.append(URLQueryItem(name: "login", value: username))
          queryItems.append(URLQueryItem(name: "api_key", value: apiKey))

          components?.queryItems = queryItems

          var newRequest = request
          newRequest.url = components?.url

          promise(.success(newRequest))
        } else {
          promise(.failure(SessionError.invalidURL))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}
