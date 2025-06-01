//
//  Product.swift
//  Products
//
//  Created by Dmytro Nosulich on 28.05.25.
//

import Foundation

struct Product: Codable, Equatable {
  let id: Int
  let title: String
  let price: Int
  let description: String
  let createdAt: Date
  let updatedAt: Date
  let imageURLs: [URL]
  let category: ProductCategory

  enum CodingKeys: String, CodingKey {
    case id
    case title
    case price
    case description
    case createdAt = "creationAt"
    case updatedAt
    case imageURLs = "images"
    case category
  }
}

