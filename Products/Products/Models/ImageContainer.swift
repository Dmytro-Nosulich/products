//
//  ImageContainer.swift
//  Products
//
//  Created by Dmytro Nosulich on 01.06.25.
//

import UIKit

struct ImageContainer: Identifiable, Equatable, Hashable {

  let id = UUID().uuidString
  let image: UIImage

  init(_ image: UIImage) {
    self.image = image
  }

  static func == (lhs: ImageContainer, rhs: ImageContainer) -> Bool {
    lhs.image == rhs.image
  }
}
