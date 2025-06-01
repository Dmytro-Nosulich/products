//
//  ProductCell.swift
//  Products
//
//  Created by Dmytro Nosulich on 29.05.25.
//

import SwiftUI

struct ProductCell: View {

  @State var product: ProductViewModel

  var body: some View {
    HStack {
      if let imageContainer = product.images.first {
        Image(uiImage: imageContainer.image)
          .resizable()
          .scaledToFit()
          .frame(width: 50, height: 50)
          .clipShape(RoundedRectangle(cornerRadius: 5))
      }

      VStack(alignment: .leading, spacing: 8) {
        Text(product.title)
          .foregroundStyle(.primary)
          .font(.body)
          .fontWeight(.semibold)
        Text(product.description)
          .lineLimit(2)
          .foregroundStyle(.secondary)
          .font(.caption)
      }

      Spacer()

      VStack(alignment: .trailing) {
        Image(systemName: product.isFavorite ? "heart.fill" : "heart")
          .foregroundStyle(.blue)

        Spacer()

        Text(product.price)
          .foregroundStyle(.green)
          .font(.title3.bold())

        Spacer()

        Text(product.createdAt)
          .foregroundStyle(.gray)
          .font(.caption2)
      }
      .padding(.vertical, 8)
    }
  }
}

#Preview {
  List {
    ProductCell(product: .mock())
  }
}
