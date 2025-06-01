//
//  ImageDownloaderProvider.swift
//  Products
//
//  Created by Dmytro Nosulich on 31.05.25.
//

import Foundation

protocol ImageDownloaderProvider {
  associatedtype Loader: ImageDownloader

  @discardableResult
  func imageDownloader(for url: URL, completion: ImageDownloaderCompletion?) -> Loader
  func cancelDownloads()
}

class GeneralImageDownloaderProvider<Loader: ImageDownloader>: ImageDownloaderProvider {

  // MARK: - Properties

  private let networkManager: NetworkManager

  private(set) var downloadersStore: [URL: Loader] = [:]

  // MARK: - Life cycle

  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
  }

  // MARK: - Public methods

  @discardableResult
  func imageDownloader(for url: URL, completion: ImageDownloaderCompletion?) -> Loader {
    if let downloader = downloadersStore[url] {
      if let completion {
        downloader.completion.append(completion)
      }
      return downloader
    } else {
      let downloader = Loader(url: url, networkManager: networkManager, completion: completion)
      downloadersStore[url] = downloader
      return downloader
    }
  }

  func cancelDownloads() {
    for downloader in downloadersStore.values {
      downloader.cancel()
    }
  }
}

final class DefaultImageDownloaderProvider: GeneralImageDownloaderProvider<DefaultImageDownloader> {}

// MARK: - Assembly

final class ImageDownloaderProviderAssembly {

  static let shared: any ImageDownloaderProvider = DefaultImageDownloaderProvider(
    networkManager: NetworkManagerAssembly.shared
  )
}
