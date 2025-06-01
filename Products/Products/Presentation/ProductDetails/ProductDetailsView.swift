//
//  ProductDetailsView.swift
//  Products
//
//  Created by Dmytro Nosulich on 28.05.25.
//

import SwiftUI

struct ProductDetailsView: View {

  @State var viewModel: ProductDetailsViewModel

  private var product: ProductViewModel {
    viewModel.product
  }

  var body: some View {
    ScrollView {
      VStack {
        imagesCarousel

        highlightsView

        ProductCategoryView(category: product.category)
      }
      .padding(.bottom)
    }
    .navigationTitle(product.title)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("", systemImage: product.isFavorite ? "heart.fill" : "heart") {
          viewModel.toggleFavoritePreference()
        }
      }
    }
    .onAppear {
      viewModel.handleOnAppear()
    }
  }

  var imagesCarousel: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: 0) {
        ForEach(product.images) { imageContainer in
          Image(uiImage: imageContainer.image)
            .resizable()
            .scaledToFit()
//            .tag(imageContainer.id)
        }
        .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
      }
      .scrollTargetLayout()
    }
    .scrollTargetBehavior(.viewAligned)
  }

  var highlightsView: some View {
    VStack(alignment: .leading) {

      Divider(height: 2)

      Text("Created: \(product.createdAt)")
        .font(.caption)
        .padding(.bottom, 8)
        .foregroundStyle(.secondary)

      Text(product.title)
        .font(.title.bold())
        .padding(.bottom, 5)

      Text(product.price)
        .foregroundStyle(.green)
        .font(.title2.bold())

      Text(product.description)

      Text("Last update: \(product.updatedAt)")
        .font(.caption)
        .padding(.top, 8)
        .foregroundStyle(.secondary)

      Divider(height: 2)
    }
    .padding(.horizontal)
  }
}

#Preview {
  NavigationStack {
    ProductDetailsView(
      viewModel: .init(
        product: .mock(),
        dependencyContainer: .init()
      )
    )
  }
}
