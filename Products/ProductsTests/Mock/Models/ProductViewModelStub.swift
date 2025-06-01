//
//  ProductViewModelStub.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 01.06.25.
//

import UIKit

extension ProductViewModel {

  static func stub(
    id: Int = .stub,
    title: String = .stub,
    price: String = .stub,
    description: String = .stub,
    createdAt: String = .stub,
    updatedAt: String = .stub,
    images: [ImageContainer] = .stub,
    category: ProductCategoryViewModel = .stub(),
    isFavorite: Bool = .stub
  ) -> ProductViewModel {
    let newModel = ProductViewModel(id: id,
                     title: title,
                     price: price,
                     description: description,
                     createdAt: createdAt,
                     updatedAt: updatedAt,
                     images: images,
                     category: category)
    newModel.isFavorite = isFavorite
    return newModel
  }
}
