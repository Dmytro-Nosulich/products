//
//  ProductCategoryViewModelBuilderTests.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 31.05.25.
//

import Testing
import UIKit

struct ProductCategoryViewModelBuilderTests {

  var productCategory: ProductCategory = .stub(
    id: 123,
    name: "some name",
    imageURL: URL(string: "www.example.com")!
  )

  func makeBuilder() -> ProductCategoryViewModelBuilder {
    ProductCategoryViewModelBuilder(productCategory: productCategory)
  }

  @Test func modelBuild() {
    // given
    let sut = makeBuilder()

    // when
    let result = sut.build()

    // then
    let expectedImage = UIImage(named: "placeholder")!

    #expect(result.id == 123)
    #expect(result.name == "some name")
    #expect(result.image.hash == expectedImage.hash)
  }

}
