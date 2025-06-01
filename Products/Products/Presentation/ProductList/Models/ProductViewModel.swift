//
//  ProductViewModel.swift
//  Products
//
//  Created by Dmytro Nosulich on 29.05.25.
//

import UIKit

@Observable
class ProductViewModel: Identifiable, Equatable {

  let id: Int
  let title: String
  let price: String
  let description: String
  let createdAt: String
  let updatedAt: String
  var images: [ImageContainer]
  let category: ProductCategoryViewModel
  var isFavorite: Bool = false

  init(id: Int,
       title: String,
       price: String,
       description: String,
       createdAt: String,
       updatedAt: String,
       images: [ImageContainer],
       category: ProductCategoryViewModel) {
    self.id = id
    self.title = title
    self.price = price
    self.description = description
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.images = images
    self.category = category
  }

  static func == (lhs: ProductViewModel, rhs: ProductViewModel) -> Bool {
    lhs.id == rhs.id
    && lhs.title == rhs.title
    && lhs.price == rhs.price
    && lhs.description == rhs.description
    && lhs.createdAt == rhs.createdAt
    && lhs.updatedAt == rhs.updatedAt
    && lhs.images == rhs.images
    && lhs.category == rhs.category
    && lhs.isFavorite == rhs.isFavorite
  }
}

struct ProductViewModelBuilder {

  let product: Product
  let favoriteProductsService: FavoriteProductsService
  var appConfigurations = AppConfigurations.shared

  func build() -> ProductViewModel {
    let images = (0..<product.imageURLs.count)
      .map { _ in ImageContainer(UIImage(named: "placeholder")!) }
    let category = ProductCategoryViewModelBuilder(productCategory: product.category).build()
    let newModel = ProductViewModel(
      id: product.id,
      title: product.title,
      price: Self.formattedPrice(product.price, for: appConfigurations),
      description: product.description,
      createdAt: Self.formattedDate(product.createdAt),
      updatedAt: Self.formattedDate(product.updatedAt),
      images: images,
      category: category
    )
    newModel.isFavorite = favoriteProductsService.isFavorite(productId: product.id)
    return newModel
  }

  static func formattedPrice(_ price: Int,
                             for appConfigurations: AppConfigurations) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.isLenient = true
    formatter.currencyCode = appConfigurations.locale.currency?.identifier

    if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
      return formattedPrice
    }

    return "\(price)"
  }

  static func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium

    return formatter.string(from: date)
  }
}

// MARK: - Mock

extension ProductViewModel {
  static func mock(id: Int = 1) -> ProductViewModel {
    .init(
      id: id,
      title: "Mock Product",
      price: "$ 100",
      description: "Mock product very very long description that may take up to several lines",
      createdAt: "25.05.2025",
      updatedAt: "28.05.2025",
      images: [ImageContainer(UIImage(named: "placeholder")!)],
      category: .mock(id: id)
    )
  }
}
