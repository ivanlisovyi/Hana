//
//  Endpoints.swift
//  
//
//  Created by Lisovyi, Ivan on 01.12.20.
//

import Foundation
import Ning

extension Endpoint {
  static func profile() -> Self {
    Endpoint(path: "/profile.json")
  }

  static func posts() -> Self {
    Endpoint(path: "/posts.json")
  }
}
