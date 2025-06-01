//
//  ProductViewModelBuilderTests.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 31.05.25.
//

import Testing
import UIKit

struct ProductViewModelBuilderTests {

  typealias SUT = ProductViewModelBuilder

  var product: Product = .stub(
    id: 12,
    title: "Product 1",
    price: 100,
    description: "Product description",
    createdAt: .stub,
    updatedAt: .stub,
    imageURLs: [URL(string: "url1")!, URL(string: "url2")!],
    category: .stub(id: 123,
                    name: "Category 1",
                    imageURL: URL(string: "www.examole.com")!)
  )
  var favoriteProductsService = FavoriteProductsServiceMock()

  func makeBuilder() -> ProductViewModelBuilder {
    ProductViewModelBuilder(product: product,
                            favoriteProductsService: favoriteProductsService)
  }

  @Test func modelBuildNotFavorite() {
    // given
    let sut = makeBuilder()

    // when
    let result = sut.build()

    // then
    let expectedImages = [
      ImageContainer(UIImage(named: "placeholder")!),
      ImageContainer(UIImage(named: "placeholder")!)
    ]
    let expectedCategory = ProductCategoryViewModel(
      id: 123,
      name: "Category 1",
      image: UIImage(named: "placeholder")!
    )
    #expect(result.id == 12)
    #expect(result.title == "Product 1")
    #expect(result.price == "€\u{00a0}100,00")
    #expect(result.description == "Product description")
    #expect(result.createdAt == "01.01.2001")
    #expect(result.updatedAt == "01.01.2001")
    #expect(result.images == expectedImages)
    #expect(result.category == expectedCategory)
    #expect(result.isFavorite == false)
  }

  @Test func modelBuildIsFavorite() {
    // given
    favoriteProductsService.isFavoriteProducts[12] = true
    let sut = makeBuilder()

    // when
    let result = sut.build()

    // then
    #expect(result.isFavorite == true)
  }

  @Test func formattedPrice() {
    // given
    let price = 888
    let appConfigurations: AppConfigurations = .shared
    appConfigurations.locale = Locale(identifier: "de_AT")

    // when
    let result = SUT.formattedPrice(price, for: appConfigurations)

    // then
    #expect(result == "€\u{00a0}888,00")
  }

  @Test func formattedDate() {
    // given
    let date = Date(timeIntervalSinceReferenceDate: 86400)

    // when
    let result = SUT.formattedDate(date)

    // then
    #expect(result == "02.01.2001")
  }
}
