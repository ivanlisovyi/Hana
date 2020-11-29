//
//  HTTPMethod.swift
//  
//
//  Created by Lisovyi, Ivan on 29.11.20.
//

import Foundation

public enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
}

extension HTTPMethod: Equatable {}
