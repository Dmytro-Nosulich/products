//
//  APICallRequestTests.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 01.06.25.
//

import Testing
import Foundation

struct APICallRequestTests {

  @Test func asURLRequest() {
    // given
    let configurations = NetworkConfiguration(baseUrl: URL(string: "https://example.com")!,
                                              headers: ["someHeader": "someValue"],
                                              cachePolicy: .returnCacheDataElseLoad,
                                              timeoutInterval: 15)
    let sut = APICallRequest(method: .post,
                             path: "some/path",
                             configuration: configurations,
                             urlParameters: [["p1": "v1"], ["p2": "v2"]])

    // when
    let result = sut.asURLRequest()

    // then
    var url = URL(string: "https://example.com/some/path")!
    url.append(queryItems: [
      .init(name: "p1", value: "v1"),
      .init(name: "p2", value: "v2")
    ])

    var expectedRequest = URLRequest(url: url)
    expectedRequest.httpMethod = "POST"
    expectedRequest.allHTTPHeaderFields = ["someHeader": "someValue"]
    expectedRequest.cachePolicy = .returnCacheDataElseLoad
    expectedRequest.timeoutInterval = 15

    #expect(result == expectedRequest)
  }
}
