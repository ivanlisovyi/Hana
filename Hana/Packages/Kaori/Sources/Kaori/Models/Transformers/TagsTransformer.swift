//
//  TagsTransformer.swift
//  
//
//  Created by Ivan Lisovyi on 08.12.20.
//

import Foundation

struct TagsTransformer {
  func transform(_ value: String) -> [String] {
    value.components(separatedBy: " ").map { "#" + $0 }
  }
}
