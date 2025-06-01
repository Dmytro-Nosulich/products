//
//  EquatableError.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 01.06.25.
//

import Foundation

struct EquatableError: Error, Equatable {
  let description: String
}

extension EquatableError: LocalizedError {
  var errorDescription: String? { description }
}
