//
//  ProductsServiceMock.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 31.05.25.
//

import Foundation

final class ProductsServiceMock: ProductsService {

  enum Invocation: Equatable {
    case fetchProductsWith(_ offset: Int, _ limit: Int)
  }
  private(set) var invocations: [Invocation] = []

  var products: [Product] = []
  var result: Result<[Product], Error> = .success([])

  func fetchProductsWith(offset: Int, limit: Int) async -> Result<[Product], Error> {
    invocations.append(.fetchProductsWith(offset, limit))
    return result
  }
}
