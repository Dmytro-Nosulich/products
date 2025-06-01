//
//  ProductListView.swift
//  Products
//
//  Created by Dmytro Nosulich on 28.05.25.
//

import SwiftUI

struct ProductListView: View {

  @State var viewModel: ProductListViewModel

  var body: some View {
    NavigationStack {
      contentView
        .navigationTitle(viewModel.title)
        .alert(viewModel.errorTitle,
               isPresented: $viewModel.isShowingError) {
          Button("OK") {
            viewModel.isShowingError = false
          }
        } message: {
          Text(viewModel.errorMessage)
        }

    }
  }

  @ViewBuilder
  private var contentView: some View {
    switch viewModel.state {
      case .initialLoad:
        initialLoad
      case .noProducts(let errorDetails):
        noProducts(with: errorDetails)
      default:
        productsList
    }
  }

  private var initialLoad: some View {
    VStack(alignment: .center) {
      Image(systemName: "square.and.arrow.down.badge.clock")
        .resizable()
        .scaledToFit()
        .frame(width: 50, height: 50)
      Text("Please, wait for data to load...")
        .font(.title)
        .fontWeight(.semibold)
        .multilineTextAlignment(.center)

      ProgressView()
        .padding()
    }
    .padding()
  }

  private var productsList: some View {
    List {
      ForEach(0..<viewModel.products.count, id: \.self) { index in
        NavigationLink {
          ProductDetailsView(viewModel: .init(product: viewModel.products[index],
                                              dependencyContainer: .init()))
        } label: {
          ProductCell(product: viewModel.products[index])
        }
        .onAppear {
          if index == viewModel.products.count - 1 {
            viewModel.didAppearLastItem()
          }
        }
      }

      if viewModel.state == .loadMore {
        loadMoreIndicator
      }
    }
  }

  private var loadMoreIndicator: some View {
    HStack {
      Spacer()
      ProgressView()
        .frame(height: 40)
      Spacer()
    }
  }

  private func noProducts(with description: String) -> some View {
    ContentUnavailableView {
      Label("Can't load products", systemImage: "xmark.icloud")
    } description: {
      Text(description)
    } actions: {
      Button("Retry") {
        viewModel.loadFirstPage()
      }
      .foregroundStyle(.blue)
    }
  }
}

#Preview {
  let viewModel = ProductListViewModel(dependencyContainer: .init())
  viewModel.state = .initialLoad
  return ProductListView(viewModel: viewModel)
}
