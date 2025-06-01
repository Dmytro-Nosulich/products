//
//  ImageDownloader.swift
//  Products
//
//  Created by Dmytro Nosulich on 31.05.25.
//

import UIKit

enum ImageDownloaderStatus {
  case notLoaded
  case loading
  case loaded
  case failed
}

typealias ImageDownloaderCompletion = (ImageDownloader) -> Void

protocol ImageDownloader: AnyObject {
  var image: UIImage? { get }
  var status: ImageDownloaderStatus { get }
  var url: URL { get }
  var completion: [ImageDownloaderCompletion] { get set }

  func download()
  func cancel()

  init(url: URL,
       networkManager: NetworkManager,
       completion: ImageDownloaderCompletion?)
}

final class DefaultImageDownloader: ImageDownloader {
  private(set) var image: UIImage?
  private(set) var status: ImageDownloaderStatus = .notLoaded
  let url: URL
  var completion: [ImageDownloaderCompletion] = []

  private let networkManager: NetworkManager
  private var task: Task<Void, Never>?

  init(url: URL,
       networkManager: NetworkManager,
       completion: ImageDownloaderCompletion? = nil) {
    self.url = url
    self.networkManager = networkManager
    if let completion {
      self.completion = [completion]
    }
  }

  func download() {
    startLoad()
  }

  func cancel() {
    status = .notLoaded
    task?.cancel()
  }
}

// MARK: - Helpers

private extension DefaultImageDownloader {

  func startLoad() {
    guard image != nil else {
      loadImage()
      return
    }

    status = .loaded
    executeCompletions()
  }

  func loadImage() {
    status = .loading
    task = Task { [weak self] in
      guard let self else { return }

      do {
        let request = DownloadRequest(url: url)
        let imageURL = try await networkManager.download(for: request)
        if let loadedImage = UIImage(contentsOfFile: imageURL.path) {
          image = loadedImage
          status = .loaded
        } else {
          status = .failed
        }
      } catch {
        status = .failed
      }

      self.task = nil
      await MainActor.run {
        self.executeCompletions()
      }
    }
  }

  func executeCompletions() {
    for completion in self.completion {
      completion(self)
    }
    self.completion.removeAll()
  }
}
