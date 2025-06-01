//
//  FavoriteProductsServiceMock.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 31.05.25.
//

import Foundation

final class FavoriteProductsServiceMock: FavoriteProductsService {

  enum Invocation: Equatable {
    case isFavorite(_ productId: Int)
    case addToFavorite(_ productId: Int)
    case removeFromFavorite(_ productId: Int)
  }
  private(set) var invocations: [Invocation] = []

  var isFavoriteProducts: [Int: Bool] = [:]

  func isFavorite(productId: Int) -> Bool {
    invocations.append(.isFavorite(productId))
    return isFavoriteProducts[productId] ?? false
  }

  func addToFavorite(productId: Int) {
    invocations.append(.addToFavorite(productId))
  }

  func removeFromFavorite(productId: Int) {
    invocations.append(.removeFromFavorite(productId))
  }
}
