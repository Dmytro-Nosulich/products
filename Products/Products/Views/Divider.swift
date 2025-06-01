//
//  Divider.swift
//  Products
//
//  Created by Dmytro Nosulich on 31.05.25.
//

import SwiftUI

struct Divider: View {

  var height: CGFloat = 2
  var verticalPadding: CGFloat = 10

  var body: some View {
    Rectangle()
      .frame(height: height)
      .foregroundStyle(.gray.opacity(0.4))
      .padding(.vertical, verticalPadding)
  }
}

#Preview {
  Divider()
}
