//
//  NetworkManagerMock.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 31.05.25.
//

import Foundation

final class NetworkManagerMock: NetworkManager {

  enum Invocation: Equatable {
    case sendRequest(_ request: URLRequest)
    case download(_ request: URLRequest)
  }
  private(set) var invocations: [Invocation] = []

  var responseForUrl: [URL: any Decodable] = [:]
  var downloadUrlForUrl: [URL: URL] = [:]
  var errorToThrow: EquatableError?

  func sendRequest<Response: Decodable>(_ request: Request) async throws -> Response {
    invocations.append(.sendRequest(request.asURLRequest()))
    if let errorToThrow {
      throw errorToThrow
    } else {
      let requestURL = request.asURLRequest().url!
      return responseForUrl[requestURL] as! Response
    }
  }

  func download(for request: Request) async throws -> URL {
    invocations.append(.download(request.asURLRequest()))
    let requestURL = request.asURLRequest().url!
    return downloadUrlForUrl[requestURL]!
  }
}
