//
//  FavoriteProductsServiceTests.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 01.06.25.
//

import Testing

struct FavoriteProductsServiceTests {

  var defaultsService = DefaultsServiceMock()

  func makeSUT() -> DefaultFavoriteProductsService {
    DefaultFavoriteProductsService(defaultsService: defaultsService)
  }

  @Test(arguments: [
    ([0, 1], 2, false),
    ([0, 1, 2], 2, true)]
  )
  func isFavoriteWhen(savedIds: [Int], idToCheck: Int, expectedResult: Bool) {
    // given
    defaultsService.itemsToRetrieve = [.favoriteProductsList: Set(savedIds)]
    let sut = makeSUT()

    // when
    let result = sut.isFavorite(productId: idToCheck)

    // then
    #expect(result == expectedResult)
    #expect(defaultsService.invocations == [
      .retrieveItem(.favoriteProductsList)
    ])
  }

  @Test(arguments: [
    ([0, 1], 2),
    ([0, 1, 2], 2)]
  )
  func addToFavorite(savedIds: [Int], idToAdd: Int) throws {
    // given
    defaultsService.itemsToRetrieve = [.favoriteProductsList: Set(savedIds)]
    let sut = makeSUT()

    // when
    sut.addToFavorite(productId: idToAdd)

    // then
    let setIds = try #require(defaultsService.setItems[.favoriteProductsList] as? Set<Int>)
    let expectedIds = Set([0, 1, 2])
    #expect(sut.favoriteProductsIds == expectedIds)
    #expect(defaultsService.invocations == [
      .retrieveItem(.favoriteProductsList)
    ])
    #expect(setIds == expectedIds)
  }

  @Test func removeFromFavoriteExistingId() throws {
    // given
    let givenIds = Set([1, 2, 3])
    defaultsService.itemsToRetrieve = [.favoriteProductsList: givenIds]
    let sut = makeSUT()

    // when
    sut.removeFromFavorite(productId: 2)

    // then
    let setIds = try #require(defaultsService.setItems[.favoriteProductsList] as? Set<Int>)
    let expectedIds = Set([1, 3])
    #expect(sut.favoriteProductsIds == expectedIds)
    #expect(defaultsService.invocations == [
      .retrieveItem(.favoriteProductsList)
    ])
    #expect(setIds == expectedIds)
  }

  @Test func removeFromFavoriteNotExistingId() {
    // given
    let givenIds = Set([1, 3])
    defaultsService.itemsToRetrieve = [.favoriteProductsList: givenIds]
    let sut = makeSUT()

    // when
    sut.removeFromFavorite(productId: 2)

    // then
    #expect(sut.favoriteProductsIds == givenIds)
    #expect(defaultsService.invocations == [
      .retrieveItem(.favoriteProductsList)
    ])
    #expect(defaultsService.setItems[.favoriteProductsList] == nil)
  }
}
