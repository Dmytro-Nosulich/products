//
//  ProductListViewModelTests.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 01.06.25.
//

import Testing
import UIKit

struct ProductListViewModelTests {

  var favoriteProductsService = FavoriteProductsServiceMock()
  var productsService = ProductsServiceMock()
  var imageDownloaderProvider = ImageDownloaderProviderMock()

  func makeSUT() -> ProductListViewModel {
    return ProductListViewModel(
      dependencyContainer:
          .init(
            favoriteProductsService: favoriteProductsService,
            productsService: productsService,
            imageDownloaderProvider: imageDownloaderProvider
          )
    )
  }

  func givenProducts(withImages: Bool = true) -> [Product] {
    (0..<10).map {
      Product.stub(id: $0,
                   imageURLs: withImages
                   ? [URL(string: "image\($0).0")!,
                      URL(string: "image\($0).1")!]
                   : .stub)
    }
  }

  func getGivenProductVMs(from products: [Product]) -> [ProductViewModel] {
    let favoriteProductsService = FavoriteProductsServiceMock()
    favoriteProductsService.isFavoriteProducts = self.favoriteProductsService.isFavoriteProducts
    return products.map {
      ProductViewModelBuilder(product: $0,
                              favoriteProductsService: favoriteProductsService)
      .build()
    }
  }

  @Test func loadFirstPageWithSuccess() async throws {
    // given
    favoriteProductsService.isFavoriteProducts = [1: true, 3: true]
    let givenProducts = givenProducts()
    let givenProductVMs = getGivenProductVMs(from: givenProducts)
    productsService.result = .success(givenProducts)

    for product in givenProducts {
      let downloader = ImageDownloaderMock(url: product.imageURLs[0],
                                           completion: nil)
      downloader.image = UIImage(named: "placeholder_test")
      imageDownloaderProvider.downloaders[product.imageURLs[0]] = downloader
    }

    for productVM in givenProductVMs {
      productVM.images[0] = ImageContainer(UIImage(named: "placeholder_test")!)
    }

    // when
    let sut = makeSUT()
    try await Task.sleep(nanoseconds: 1_000_000_000)

    // then
    #expect(sut.state == .loaded)
    #expect(sut.products == givenProductVMs)
    #expect(sut.title == "Products (10)")
    #expect(sut.errorTitle == "")
    #expect(sut.errorMessage == "")
    #expect(sut.isShowingError == false)
    #expect(productsService.invocations == [
      .fetchProductsWith(0, 10)
    ])
    let imageDownloaderProviderMockInvocation = (0..<10).map {
      ImageDownloaderProviderMock.Invocation.imageDownloader(URL(string: "image\($0).0")!, true)
    }
    #expect(imageDownloaderProvider.invocations == imageDownloaderProviderMockInvocation)
    let favoriteProductsServiceInvocation = (0..<10).map {
      FavoriteProductsServiceMock.Invocation.isFavorite($0)
    }
    #expect(favoriteProductsService.invocations == favoriteProductsServiceInvocation)
  }

  @Test func loadFirstPageWithFailure() async throws {
    // given
    productsService.result = .failure(EquatableError(description: "no products"))

    // when
    let sut = makeSUT()
    try await Task.sleep(nanoseconds: 1_000_000_000)

    // then
    #expect(sut.state == .noProducts("no products"))
    #expect(sut.products.isEmpty == true)
    #expect(sut.title == "Products")
    #expect(sut.errorTitle == "")
    #expect(sut.errorMessage == "")
    #expect(sut.isShowingError == false)
    #expect(productsService.invocations == [
      .fetchProductsWith(0, 10)
    ])
    #expect(imageDownloaderProvider.invocations.isEmpty == true)
    #expect(favoriteProductsService.invocations.isEmpty == true)
  }

  @Test(arguments: [ProductListViewModel.State.initialLoad, .loadMore, .noProducts(.stub)])
  func didAppearLastItemWithWrongState(state: ProductListViewModel.State) async throws {
    // given
    let givenProducts = givenProducts(withImages: false)
    let givenProductVMs = getGivenProductVMs(from: givenProducts)
    productsService.result = .success(givenProducts)

    // when
    let sut = makeSUT()
    try await Task.sleep(nanoseconds: 1_000_000_000)
    sut.state = state
    sut.didAppearLastItem()
    try await Task.sleep(nanoseconds: 1_000_000_000)

    // then
    #expect(sut.state == state)
    #expect(sut.products == givenProductVMs)
    #expect(sut.title == "Products (10)")
    #expect(sut.errorTitle == "")
    #expect(sut.errorMessage == "")
    #expect(sut.isShowingError == false)
    #expect(productsService.invocations == [
      .fetchProductsWith(0, 10)
    ])
  }

  @Test func didAppearLastItemWithCorrectState() async throws {
    // given
    let givenProducts = givenProducts(withImages: false)
    let givenProductVMs = getGivenProductVMs(from: givenProducts)
    productsService.result = .success(givenProducts)

    // when
    let sut = makeSUT()
    try await Task.sleep(nanoseconds: 1_000_000_000)
    let givenProductsNext: [Product] = [.stub(id: 11), .stub(id: 12) ]
    let givenProductVMsNext = getGivenProductVMs(from: givenProductsNext)
    productsService.result = .success(givenProductsNext)
    sut.didAppearLastItem()
    try await Task.sleep(nanoseconds: 1_000_000_000)

    // Since previous page was not full next page load shouldn't be executed
    sut.didAppearLastItem()
    try await Task.sleep(nanoseconds: 1_000_000_000)

    // then
    #expect(sut.state == .loaded)
    #expect(sut.products == givenProductVMs + givenProductVMsNext)
    #expect(sut.title == "Products (12)")
    #expect(sut.errorTitle == "")
    #expect(sut.errorMessage == "")
    #expect(sut.isShowingError == false)
    #expect(productsService.invocations == [
      .fetchProductsWith(0, 10),
      .fetchProductsWith(10, 10)
    ])
  }
}
