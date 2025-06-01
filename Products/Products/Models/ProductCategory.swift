//
//  ProductCategory.swift
//  Products
//
//  Created by Dmytro Nosulich on 28.05.25.
//

import Foundation

struct ProductCategory: Codable, Equatable {
  let id: Int
  let name: String
  let imageURL: URL

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case imageURL = "image"
  }
}
