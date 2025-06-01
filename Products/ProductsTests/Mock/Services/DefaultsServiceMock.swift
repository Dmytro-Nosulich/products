//
//  DefaultsServiceMock.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 31.05.25.
//

import Foundation

final class DefaultsServiceMock: DefaultsService {

  enum Invocation: Equatable {
    case retrieveItem(_ key: DefaultsServiceKey)
    case removeItem(_ key: DefaultsServiceKey)
  }
  private(set) var invocations: [Invocation] = []

  private(set) var setItems: [DefaultsServiceKey: Any] = [:]
  var itemsToRetrieve: [DefaultsServiceKey: Any] = [:]

  func setItem<T: Codable>(_ item: T, for key: DefaultsServiceKey) {
    setItems[key] = item
  }

  func retrieveItem<T: Codable>(for key: DefaultsServiceKey) -> T? {
    invocations.append(.retrieveItem(key))
    return itemsToRetrieve[key] as? T
  }

  func removeItem(for key: DefaultsServiceKey) {
    invocations.append(.removeItem(key))
  }
}
