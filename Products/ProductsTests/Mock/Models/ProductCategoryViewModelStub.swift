//
//  ProductCategoryViewModelStub.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 01.06.25.
//

import UIKit

extension ProductCategoryViewModel {

  static func stub(
    id: Int = .stub,
    name: String = .stub,
    image: UIImage = UIImage()
  ) -> ProductCategoryViewModel {
    ProductCategoryViewModel(
      id: id,
      name: name,
      image: image
    )
  }
}
