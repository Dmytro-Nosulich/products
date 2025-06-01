//
//  Sequence+Utils.swift
//  Products
//
//  Created by Dmytro Nosulich on 01.06.25.
//

import Foundation

extension Sequence where Element: Hashable {

  func indexes(of element: Element) -> IndexSet {
    var indexes = [Int]()
    for (index, value) in self.enumerated() {
      if value == element {
        indexes.append(index)
      }
    }
    return IndexSet(indexes)
  }
}
