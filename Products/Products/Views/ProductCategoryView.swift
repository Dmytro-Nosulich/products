//
//  ProductCategoryView.swift
//  Products
//
//  Created by Dmytro Nosulich on 31.05.25.
//

import SwiftUI

struct ProductCategoryView: View {

  @State var category: ProductCategoryViewModel

  var body: some View {
    VStack(alignment: .leading) {
      Text("Category")
        .font(.title.bold())
        .padding(.bottom, 5)

      HStack {
        Image(uiImage: category.image)
          .resizable()
          .scaledToFill()
          .frame(width: 50, height: 50)
          .clipShape(.circle)
          .shadow(radius: 5)

        Text(category.name)
          .font(.body)
          .padding(.bottom, 5)

        Spacer()
      }
    }
    .padding(.horizontal)
  }
}

#Preview {
  ProductCategoryView(category: .mock())
}
