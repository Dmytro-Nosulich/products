//
//  NetworkConfiguration.swift
//  Products
//
//  Created by Dmytro Nosulich on 30.05.25.
//

import Foundation

struct NetworkConfiguration {
  let baseUrl: URL
  let headers: [String: String]
  let cachePolicy: URLRequest.CachePolicy
  let timeoutInterval: TimeInterval
}

extension NetworkConfiguration {
  static let `default`: NetworkConfiguration = .init(
    baseUrl: URL(string: "https://api.escuelajs.co/api/v1")!,
    headers: ["Content-type": "application/json"],
    cachePolicy: .useProtocolCachePolicy,
    timeoutInterval: 10
  )
}
