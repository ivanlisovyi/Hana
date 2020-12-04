//
//  Endpoints.swift
//  
//
//  Created by Lisovyi, Ivan on 01.12.20.
//

import Foundation
import Ning

extension Endpoint {
  static func authenticate(username: String, apiKey: String) -> Self {
    Endpoint(
      path: "profile.json",
      parameters: [
        "login": username,
        "api_key": apiKey
      ]
    )
  }

  static func posts() -> Self {
    Endpoint(path: "/posts.json")
  }
}
