//
//  DownloadRequestTests.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 01.06.25.
//

import Testing
import Foundation

struct DownloadRequestTests {

  @Test func asURLRequest() {
    // given
    let configurations = NetworkConfiguration(baseUrl: .stub,
                                              headers: .stub,
                                              cachePolicy: .returnCacheDataElseLoad,
                                              timeoutInterval: 20)
    let sut = DownloadRequest(url: URL(string: "https://someimage.com")!,
                              configuration: configurations)

    // when
    let result = sut.asURLRequest()

    // then
    let url = URL(string: "https://someimage.com")!
    var expectedRequest = URLRequest(url: url)
    expectedRequest.httpMethod = "GET"
    expectedRequest.cachePolicy = .returnCacheDataElseLoad
    expectedRequest.timeoutInterval = 20

    #expect(result == expectedRequest)
  }
}
