//
//  Product.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 31.05.25.
//

import Foundation

extension Product {
  static func stub(
    id: Int = .stub,
    title: String = .stub,
    price: Int = .stub,
    description: String = .stub,
    createdAt: Date = .stub,
    updatedAt: Date = .stub,
    imageURLs: [URL] = .stub,
    category: ProductCategory = .stub(),
  ) -> Product {
    Product(id: id,
            title: title,
            price: price,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
            imageURLs: imageURLs,
            category: category
    )
  }
}
