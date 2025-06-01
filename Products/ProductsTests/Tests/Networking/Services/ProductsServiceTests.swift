//
//  ProductsServiceTests.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 01.06.25.
//

import Testing
import Foundation

struct ProductsServiceTests {

  var networkManager = NetworkManagerMock()
  var urlStub = URL(string: "https://api.escuelajs.co/api/v1/products")!

  func makeSUT() -> DefaultProductsService {
    return DefaultProductsService(networkManager: networkManager)
  }

  func requestStub(offset: Int, limit: Int) -> URLRequest {
    var url = urlStub
    url.append(queryItems: [
      .init(name: "offset", value: "\(offset)"),
      .init(name: "limit", value: "\(limit)")
    ])

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = ["Content-type": "application/json"]
    request.cachePolicy = .useProtocolCachePolicy
    request.timeoutInterval = 10
    return request
  }

  @Test func fetchProductsWithSuccess() async {
    // given
    let givenProducts = [
      Product.stub(id: 1),
      Product.stub(id: 2),
      Product.stub(id: 3)
    ]
    let request = requestStub(offset: 5, limit: 7)
    networkManager.responseForUrl = [request.url!: givenProducts]
    let sut = makeSUT()

    // when
    let result = await sut.fetchProductsWith(offset: 5, limit: 7)

    // then
    switch result {
      case .success(let products):
        #expect(products == givenProducts)
      case .failure:
        Issue.record("Expected success, got failure instead")
    }
    #expect(sut.products == givenProducts)
    #expect(networkManager.invocations == [
      .sendRequest(request)
    ])
  }

  @Test func fetchProductsWithSuccess2Times() async {
    // given
    let products1 = [
      Product.stub(id: 1),
      Product.stub(id: 2),
      Product.stub(id: 3)
    ]
    let products2 = [
      Product.stub(id: 4),
      Product.stub(id: 5)
    ]
    let request1 = requestStub(offset: 0, limit: 7)
    let request2 = requestStub(offset: 7, limit: 10)
    networkManager.responseForUrl = [request1.url!: products1]
    networkManager.responseForUrl[request2.url!] = products2
    let sut = makeSUT()

    // when
    let result1 = await sut.fetchProductsWith(offset: 0, limit: 7)
    let result2 = await sut.fetchProductsWith(offset: 7, limit: 10)

    // then
    switch result1 {
      case .success(let products):
        #expect(products == products1)
      case .failure:
        Issue.record("Expected success, got failure instead")
    }
    switch result2 {
      case .success(let products):
        #expect(products == products2)
      case .failure:
        Issue.record("Expected success, got failure instead")
    }
    #expect(sut.products == products1 + products2)
    #expect(networkManager.invocations == [
      .sendRequest(request1),
      .sendRequest(request2)
    ])
  }

  @Test func fetchProductsWithError() async {
    // given
    let request = requestStub(offset: 1, limit: 2)
    networkManager.errorToThrow = EquatableError(description: "error happened")
    let sut = makeSUT()

    // when
    let result = await sut.fetchProductsWith(offset: 1, limit: 2)

    // then
    switch result {
      case .success:
        Issue.record("Expected success, got failure instead")
      case .failure(let error):
        if let error = error as? EquatableError {
          #expect(error.description == "error happened")
        } else {
          Issue.record("Expected error of type 'EquatableError'")
        }
    }
    #expect(sut.products.isEmpty == true)
    #expect(networkManager.invocations == [
      .sendRequest(request)
    ])
  }
}
