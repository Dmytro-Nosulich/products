//
//  ImageDownloaderMock.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 31.05.25.
//

import UIKit

final class ImageDownloaderMock: ImageDownloader {

  enum Invocation: Equatable {
    case initWith(_ url: URL?, _ withCompletion: Bool)
    case download
    case cancel
  }
  private(set) var invocations: [Invocation] = []

  var image: UIImage?
  var status: ImageDownloaderStatus = .notLoaded
  var url: URL
  var completion: [ImageDownloaderCompletion] = []

  init(url: URL,
       networkManager: NetworkManager = NetworkManagerMock(),
       completion: ImageDownloaderCompletion?) {
    self.url = url
    if let completion {
      self.completion.append(completion)
    }
    invocations.append(.initWith(url, completion != nil))
  }

  func download() {
    invocations.append(.download)
    for completion in self.completion {
      completion(self)
    }
  }

  func cancel() {
    invocations.append(.cancel)
  }
}
