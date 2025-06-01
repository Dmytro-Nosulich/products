//
//  ProductCategory.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 31.05.25.
//

import Foundation

extension ProductCategory {
  public static func stub(
    id: Int = .stub,
    name: String = .stub,
    imageURL: URL = .stub
  ) -> ProductCategory {
    ProductCategory(id: id,
                    name: name,
                    imageURL: imageURL)
  }
}
