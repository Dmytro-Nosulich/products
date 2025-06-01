//
//  ProductDetailsViewModel.swift
//  Products
//
//  Created by Dmytro Nosulich on 30.05.25.
//

import Foundation

@Observable
final class ProductDetailsViewModel {

  let product: ProductViewModel

  private let favoriteProductsService: FavoriteProductsService
  private let productsService: ProductsService
  private let imageDownloaderProvider: any ImageDownloaderProvider

  // MARK: - Life cycle

  init(product: ProductViewModel, dependencyContainer: DependencyContainer) {
    self.product = product
    self.favoriteProductsService = dependencyContainer.favoriteProductsService
    self.productsService = dependencyContainer.productsService
    self.imageDownloaderProvider = dependencyContainer.imageDownloaderProvider
  }

  // MARK: - Public methods

  func toggleFavoritePreference() {
    product.isFavorite.toggle()
    if product.isFavorite {
      favoriteProductsService.addToFavorite(productId: product.id)
    } else {
      favoriteProductsService.removeFromFavorite(productId: product.id)
    }
  }

  func handleOnAppear() {
    loadProductImages()
  }
}

// MARK: - Helpers

private extension ProductDetailsViewModel {

  func loadProductImages() {
    guard let product = productsService.products.first(where: { $0.id == self.product.id }) else {
      return
    }
    loadImageFor(product: product)
    loadCategoryImage(for: product)
  }

  func loadImageFor(product: Product) {
    for imageURL in product.imageURLs {
      imageDownloaderProvider.imageDownloader(for: imageURL) { [weak self] downloader in
        guard let self,
              let loadedImage = downloader.image else { return }

        let urlIndexes = product.imageURLs.indexes(of: downloader.url)
        for index in urlIndexes {
          if self.product.images.count > index {
            self.product.images[index] = ImageContainer(loadedImage)
          } else {
            self.product.images.append(ImageContainer(loadedImage))
          }
        }
      }
      .download()
    }
  }

  func loadCategoryImage(for product: Product) {
    let categoryImageUrl = product.category.imageURL
    imageDownloaderProvider.imageDownloader(for: categoryImageUrl) { [weak self] downloader in
      guard let self,
            let loadedImage = downloader.image else { return }

      self.product.category.image = loadedImage
    }
    .download()
  }
}

// MARK: - DependencyContainer

extension ProductDetailsViewModel {
  
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
