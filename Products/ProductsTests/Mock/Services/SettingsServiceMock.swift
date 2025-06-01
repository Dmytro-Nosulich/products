//
//  SettingsServiceMock.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 31.05.25.
//

import Foundation

final class SettingsServiceMock: SettingsService {

  private(set) var savedSettings: [Settings] = []

  var settings: Settings = .init()

  func saveSettings(_ settings: Settings) {
    savedSettings.append(settings)
  }
}
