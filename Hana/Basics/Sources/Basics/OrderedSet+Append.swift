//
//  OrderedSet+Append.swift
//  
//
//  Created by Ivan Lisovyi on 09.12.20.
//

import Foundation

public extension OrderedSet {
  mutating func append<S: Sequence>(contentsOf sequence: S) where S.Element == Element {
    sequence.forEach { append($0) }
  }
}
