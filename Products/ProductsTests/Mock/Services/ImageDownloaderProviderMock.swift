//
//  ImageDownloaderProviderMock.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 31.05.25.
//

import Foundation
import Testing

final class ImageDownloaderProviderMock: ImageDownloaderProvider {

  enum Invocation: Equatable {
    case imageDownloader(_ url: URL, _ withCompletion: Bool)
    case cancelDownloads
  }
  private(set) var invocations: [Invocation] = []

  var downloaders: [URL: ImageDownloaderMock] = [:]

  @discardableResult
  func imageDownloader(for url: URL, completion: ImageDownloaderCompletion?) -> ImageDownloaderMock {
    guard let downloader = downloaders[url] else {
      #expect(Bool(false), "Downloader not found for \(url)")
      fatalError()
    }
    invocations.append(.imageDownloader(url, completion != nil))
    if let completion {
      downloader.completion.append(completion)
    }
    return downloader
  }

  func cancelDownloads() {
    invocations.append(.cancelDownloads)
  }
}
