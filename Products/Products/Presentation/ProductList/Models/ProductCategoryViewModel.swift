//
//  ProductCategoryViewModel.swift
//  Products
//
//  Created by Dmytro Nosulich on 29.05.25.
//

import UIKit

@Observable
class ProductCategoryViewModel: Identifiable, Equatable {

  let id: Int
  let name: String
  var image: UIImage

  init(id: Int, name: String, image: UIImage) {
    self.id = id
    self.name = name
    self.image = image
  }

  static func == (lhs: ProductCategoryViewModel, rhs: ProductCategoryViewModel) -> Bool {
    lhs.id == rhs.id
    && lhs.name == rhs.name
    && lhs.image == rhs.image
  }
}

struct ProductCategoryViewModelBuilder {

  let productCategory: ProductCategory

  func build() -> ProductCategoryViewModel {
    .init(
      id: productCategory.id,
      name: productCategory.name,
      image: UIImage(named: "placeholder")!
    )
  }
}

// MARK: - Mock

extension ProductCategoryViewModel {
  static func mock(id: Int = 1) -> ProductCategoryViewModel {
    .init(
      id: id,
      name: "Category name",
      image: UIImage(named: "placeholder")!
    )
  }
}
