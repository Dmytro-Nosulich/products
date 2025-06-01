//
//  FavoriteProductsService.swift
//  Products
//
//  Created by Dmytro Nosulich on 28.05.25.
//

import Foundation

protocol FavoriteProductsService {
  func isFavorite(productId: Int) -> Bool
  func addToFavorite(productId: Int)
  func removeFromFavorite(productId: Int)
}

class DefaultFavoriteProductsService: FavoriteProductsService {

  typealias FavoriteProducts = Set<Int>

  private(set) var favoriteProductsIds: FavoriteProducts
  private let defaultsService: DefaultsService

  init(defaultsService: DefaultsService) {
    self.defaultsService = defaultsService
    self.favoriteProductsIds = defaultsService.retrieveItem(for: .favoriteProductsList) ?? []
  }

  func isFavorite(productId: Int) -> Bool {
    favoriteProductsIds.contains(productId)
  }
  
  func addToFavorite(productId: Int) {
    favoriteProductsIds.insert(productId)
    saveFavoriteProductsIds()
  }

  func removeFromFavorite(productId: Int) {
    if favoriteProductsIds.remove(productId) != nil {
      saveFavoriteProductsIds()
    }
  }

  // MARK: - Helpers

  private func saveFavoriteProductsIds() {
    defaultsService.setItem(favoriteProductsIds, for: .favoriteProductsList)
  }
}

// MARK: - Assembly

final class FavoriteProductsServiceAssembly {
  static let shared: FavoriteProductsService = DefaultFavoriteProductsService(defaultsService: DefaultsServiceAssembly.standard)
}
