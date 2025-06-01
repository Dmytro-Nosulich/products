//
//  GeneralImageDownloaderProviderTests.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 01.06.25.
//

import Testing
import Foundation

struct GeneralImageDownloaderProviderTests {

  typealias MockProvider = GeneralImageDownloaderProvider<ImageDownloaderMock>

  var networkManager = NetworkManagerMock()

  func makeSUT() -> MockProvider {
    MockProvider(networkManager: networkManager)
  }

  @Test func creationOfNewDownloaders() throws {
    // given
    let url = try #require(URL(string: "some_url"))
    let sut = makeSUT()

    // when
    let downloader = sut.imageDownloader(for: url, completion: { _ in })

    // then
    #expect(sut.downloadersStore.count == 1)
    #expect(downloader.invocations == [.initWith(url, true)])
    #expect(downloader.url == url)
    #expect(downloader.status == .notLoaded)
    #expect(downloader.image == nil)
    #expect(downloader.completion.count == 1)
  }

  @Test func retrievingOfExistingDownloaders() throws {
    // given
    let url = try #require(URL(string: "some_url"))
    let sut = makeSUT()
    sut.imageDownloader(for: url, completion: nil)

    // when
    let downloader = sut.imageDownloader(for: url, completion: nil)

    // then
    #expect(sut.downloadersStore.count == 1)
    #expect(downloader.invocations == [.initWith(url, false)])
    #expect(downloader.url == url)
    #expect(downloader.status == .notLoaded)
    #expect(downloader.image == nil)
    #expect(downloader.completion.isEmpty == true)
  }

  @Test func cancelingDownloaders() throws {
    // given
    let url1 = try #require(URL(string: "some_url1"))
    let url2 = try #require(URL(string: "some_url2"))
    let sut = makeSUT()

    // when
    let downloader1 = sut.imageDownloader(for: url1, completion: nil)
    downloader1.download()
    let downloader2 = sut.imageDownloader(for: url2, completion: nil)
    downloader2.download()
    sut.cancelDownloads()

    // then
    #expect(sut.downloadersStore.count == 2)
    #expect(downloader1.invocations == [.initWith(url1, false), .download, .cancel])
    #expect(downloader1.status == .notLoaded)
    #expect(downloader2.invocations == [.initWith(url2, false), .download, .cancel])
    #expect(downloader2.status == .notLoaded)
  }
}
