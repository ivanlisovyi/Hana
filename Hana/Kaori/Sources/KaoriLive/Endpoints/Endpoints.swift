//
//  Endpoints.swift
//  
//
//  Created by Lisovyi, Ivan on 01.12.20.
//

import Foundation
import Ning

public extension Endpoint {
  static func profile() -> Self {
    Endpoint(path: "/profile.json")
  }

  static func posts(page: Int = 1) -> Self {
    Endpoint(
      path: "/posts.json",
      parameters: [
        "page": page
      ]
    )
  }
}
