//
//  DefaultsService.swift
//  Products
//
//  Created by Dmytro Nosulich on 28.05.25.
//

import Foundation

// MARK: - Keys

enum DefaultsServiceKey: String {
  /// Key for settings details
  case settingsDetail

  /// Key for a list of favorite products
  case favoriteProductsList
}

extension DefaultsServiceKey {
  var keyPrefix: String {
    return "pre_"
  }

  var key: String {
    return keyPrefix + rawValue
  }
}

// MARK: - Service

protocol DefaultsService {
  func setItem<T: Codable>(_ item: T, for key: DefaultsServiceKey)
  func retrieveItem<T: Codable>(for key: DefaultsServiceKey) -> T?
  func removeItem(for key: DefaultsServiceKey)
}

struct DefaultsServiceDefault: DefaultsService {

  private var store = UserDefaults.standard

  func setItem<T: Codable>(_ item: T, for key: DefaultsServiceKey) {
    let data = try? JSONEncoder().encode(item)
    store.set(data, forKey: key.key)
  }

  func retrieveItem<T: Codable>(for key: DefaultsServiceKey) -> T? {
    guard let data = store.value(forKey: key.key) as? Data else {
      return nil
    }
    let object = try? JSONDecoder().decode(T.self, from: data)
    return object
  }

  func removeItem(for key: DefaultsServiceKey) {
    store.set(nil, forKey: key.key)
  }
}

// MARK: - Assembly

final class DefaultsServiceAssembly {
  static let standard: DefaultsService = DefaultsServiceDefault()
}
