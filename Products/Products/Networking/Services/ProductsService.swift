//
//  UserService.swift
//  Products
//
//  Created by Dmytro Nosulich on 29.05.25.
//

import Foundation

protocol ProductsService {

  var products: [Product] { get }
  func fetchProductsWith(offset: Int, limit: Int) async -> Result<[Product], Error>
}

final class DefaultProductsService: ProductsService {

  // MARK: - Properties

  var products: [Product] = []

  private let networkManager: NetworkManager

  // MARK: - Life cycle

  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
  }

  // MARK: - Public methods

  func fetchProductsWith(offset: Int, limit: Int) async -> Result<[Product], Error> {
    var request = APICallRequest(method: .get, path: "products")
    request.urlParameters = [["offset": "\(offset)"], ["limit": "\(limit)"]]
    let result: Result<[Product], Error>
    do {
      let products: [Product] = try await networkManager.sendRequest(request)
      self.products.append(contentsOf: products)
      result = .success(products)
    } catch {
      result = .failure(error)
    }

    return result
  }
}

// MARK: - Assembly

final class ProductsServiceAssembly {
  static let shared: ProductsService = DefaultProductsService(networkManager: NetworkManagerAssembly.shared)
}
