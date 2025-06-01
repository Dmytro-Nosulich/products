//
//  ProductListViewModel.swift
//  Products
//
//  Created by Dmytro Nosulich on 29.05.25.
//

import Foundation

@Observable
class ProductListViewModel {

  enum State: Equatable {
    case initialLoad
    case loaded
    case loadMore
    case noProducts(_ errorDetails: String)
  }

  // MARK: - Properties

  var products: [ProductViewModel] = []
  var title: String = "Products"
  var state: State = .initialLoad

  var errorTitle: String = ""
  var errorMessage: String = ""
  var isShowingError: Bool = false

  private let favoriteProductsService: FavoriteProductsService
  private let productsService: ProductsService
  private let imageDownloaderProvider: any ImageDownloaderProvider

  private let loadPageSize: Int = 10
  private var pageOffset: Int = 0
  private var needLoadMore: Bool = true

  // MARK: - Life cycle

  init(dependencyContainer: DependencyContainer) {
    self.favoriteProductsService = dependencyContainer.favoriteProductsService
    self.productsService = dependencyContainer.productsService
    self.imageDownloaderProvider = dependencyContainer.imageDownloaderProvider

    loadFirstPage()
  }

  // MARK: - Public methods

  func loadFirstPage() {
    state = .initialLoad
    pageOffset = 0
    needLoadMore = true
    loadProducts()
  }

  func didAppearLastItem() {
    guard state == .loaded, needLoadMore else { return }
    loadNextPage()
  }
}

// MARK: - Helpers

private extension ProductListViewModel {

  func loadNextPage() {
    state = .loadMore
    pageOffset += loadPageSize
    loadProducts()
  }

  func loadProducts() {
    Task {
      let productsResult = await productsService.fetchProductsWith(
        offset: pageOffset,
        limit: loadPageSize
      )

      handleProductsResult(productsResult)
    }
  }

  func handleProductsResult(_ result: Result<[Product], Error>) {
    switch result {
      case .success(let products):
        let newProducts = products.map {
          ProductViewModelBuilder(product: $0,
                                  favoriteProductsService: favoriteProductsService)
          .build()
        }

        self.products.append(contentsOf: newProducts)
        state = .loaded
        needLoadMore = newProducts.count >= loadPageSize

        loadImagesFor(products: products)
      case .failure(let error):
        if state == .loadMore {
          errorTitle = "Loading error"
          errorTitle = error.localizedDescription
          isShowingError = true
        }

        state = products.isEmpty ? .noProducts(error.localizedDescription) : .loaded
    }

    updateTitle()
  }

  func updateTitle() {
    if !products.isEmpty {
      title = "Products (\(products.count))"
    } else {
      title = "Products"
    }
  }

  func loadImagesFor(products: [Product]) {
    for product in products {
      loadImageFor(product: product)
    }
  }

  func loadImageFor(product: Product) {
    guard let imageURL = product.imageURLs.first else {
      return
    }

    imageDownloaderProvider.imageDownloader(for: imageURL) { [weak self] downloader in
      guard let self,
            let loadedImage = downloader.image else { return }

      guard let productViewModel = products.first(where: { $0.id == product.id }) else {
        return
      }

      if !productViewModel.images.isEmpty {
        productViewModel.images[0] = ImageContainer(loadedImage)
      }
    }
    .download()
  }
}

// MARK: - DependencyContainer

extension ProductListViewModel {

  struct DependencyContainer {
    let favoriteProductsService: FavoriteProductsService
    let productsService: ProductsService
    let imageDownloaderProvider: any ImageDownloaderProvider

    init(
      favoriteProductsService: FavoriteProductsService = FavoriteProductsServiceAssembly.shared,
      productsService: ProductsService = ProductsServiceAssembly.shared,
      imageDownloaderProvider: any ImageDownloaderProvider = ImageDownloaderProviderAssembly.shared
    ) {
      self.favoriteProductsService = favoriteProductsService
      self.productsService = productsService
      self.imageDownloaderProvider = imageDownloaderProvider
    }
  }
}
