//
//  RequestStub.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 01.06.25.
//

import Foundation

struct RequestStub: Request {

  let url: URL

  init(
    url: URL = URL(string: "https://example.com")!
  ) {
    self.url = url
  }

  func asURLRequest() -> URLRequest {
    URLRequest(url: url)
  }
}
