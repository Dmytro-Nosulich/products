//
//  Request.swift
//  Products
//
//  Created by Dmytro Nosulich on 29.05.25.
//

import Foundation

protocol Request {
  func asURLRequest() -> URLRequest
}

struct APICallRequest: Request {
  let method: HTTPMethod
  let path: String
  var configuration: NetworkConfiguration = .default
  var urlParameters: [[String: String]] = []

  func asURLRequest() -> URLRequest {
    var url = configuration.baseUrl.appending(path: path)
    for urlParams in urlParameters {
      for urlParam in urlParams {
        url.append(queryItems: [
          .init(name: urlParam.key, value: urlParam.value),
        ])
      }
    }

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method.toString()
    urlRequest.allHTTPHeaderFields = configuration.headers
    urlRequest.cachePolicy = configuration.cachePolicy
    urlRequest.timeoutInterval = configuration.timeoutInterval
    return urlRequest
  }
}

struct DownloadRequest: Request {

  let url: URL
  var configuration: NetworkConfiguration = .default

  func asURLRequest() -> URLRequest {
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = HTTPMethod.get.toString()
    urlRequest.cachePolicy = .returnCacheDataElseLoad
    urlRequest.timeoutInterval = configuration.timeoutInterval
    return urlRequest
  }
}

enum HTTPMethod: String {
  case get
  case post
  case put
  case delete

  func toString() -> String {
    return rawValue.uppercased()
  }
}
