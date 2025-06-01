//
//  ProductDetailsViewModelTests.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 01.06.25.
//

import Testing
import UIKit

struct ProductDetailsViewModelTests {

  var favoriteProductsService = FavoriteProductsServiceMock()
  var productsService = ProductsServiceMock()
  var imageDownloaderProvider = ImageDownloaderProviderMock()

  func makeSUT(with product: ProductViewModel = .stub(id: 1)) -> ProductDetailsViewModel {
    ProductDetailsViewModel(
      product: product,
      dependencyContainer: .init(
        favoriteProductsService: favoriteProductsService,
        productsService: productsService,
        imageDownloaderProvider: imageDownloaderProvider
      )
    )
  }

  @Test func toggleFavoritePreferenceWhenIsNotFavorite() {
    // given
    let sut = makeSUT(with: .stub(id: 1, isFavorite: false))

    // when
    sut.toggleFavoritePreference()

    // then
    #expect(sut.product.isFavorite == true)
    #expect(favoriteProductsService.invocations == [.addToFavorite(1)])
  }

  @Test func toggleFavoritePreferenceWhenIsFavorite() {
    // given
    let sut = makeSUT(with: .stub(id: 3, isFavorite: true))

    // when
    sut.toggleFavoritePreference()

    // then
    #expect(sut.product.isFavorite == false)
    #expect(favoriteProductsService.invocations == [.removeFromFavorite(3)])
  }

  @Test func handleOnAppear() {
    // given
    let productImageUrls = [
      URL(string: "image1")!,
      URL(string: "image2")!,
      URL(string: "image3")!
    ]
    let categoryImageURL = URL(string: "categoryImage")!
    let product = Product.stub(id: 10,
                               imageURLs: productImageUrls,
                               category: .stub(imageURL: categoryImageURL))
    let productVM = ProductViewModelBuilder(product: product,
                                            favoriteProductsService: favoriteProductsService).build()
    // add downloaders for product images
    for url in productImageUrls {
      let downloader = ImageDownloaderMock(url: url,
                                           completion: nil)
      downloader.image = UIImage(named: "placeholder_test")
      imageDownloaderProvider.downloaders[url] = downloader
    }
    // add downloaders for product category image
    let downloader = ImageDownloaderMock(url: categoryImageURL,
                                         completion: nil)
    downloader.image = UIImage(named: "placeholder_test")
    imageDownloaderProvider.downloaders[categoryImageURL] = downloader

    productsService.products = [product]
    let sut = makeSUT(with: productVM)

    // when
    sut.handleOnAppear()

    // then
    #expect(sut.product.images == [
      ImageContainer(UIImage(named: "placeholder_test")!),
      ImageContainer(UIImage(named: "placeholder_test")!),
      ImageContainer(UIImage(named: "placeholder_test")!)
    ])
    #expect(sut.product.category.image == UIImage(named: "placeholder_test"))
    #expect(imageDownloaderProvider.invocations == [
      .imageDownloader(URL(string: "image1")!, true),
      .imageDownloader(URL(string: "image2")!, true),
      .imageDownloader(URL(string: "image3")!, true),
      .imageDownloader(URL(string: "categoryImage")!, true)
    ])
  }

  @Test func handleOnAppearWhenNoNeededProdInService() {
    // given
    let productImageUrls = [
      URL(string: "image1")!,
      URL(string: "image2")!,
      URL(string: "image3")!
    ]
    let categoryImageURL = URL(string: "categoryImage")!
    let product = Product.stub(id: 999,
                               imageURLs: productImageUrls,
                               category: .stub(imageURL: categoryImageURL))
    let product1 = Product.stub(id: 111,
                               imageURLs: productImageUrls,
                               category: .stub(imageURL: categoryImageURL))
    let productVM = ProductViewModelBuilder(product: product1,
                                            favoriteProductsService: favoriteProductsService).build()

    productsService.products = [product]
    let sut = makeSUT(with: productVM)

    // when
    sut.handleOnAppear()

    // then
    #expect(sut.product.images == [
      ImageContainer(UIImage(named: "placeholder")!),
      ImageContainer(UIImage(named: "placeholder")!),
      ImageContainer(UIImage(named: "placeholder")!)
    ])
    #expect(sut.product.category.image == UIImage(named: "placeholder"))
    #expect(imageDownloaderProvider.invocations.isEmpty == true)
  }
}
