//
//  SettingsService.swift
//  Products
//
//  Created by Dmytro Nosulich on 28.05.25.
//

import Foundation

protocol SettingsService {
  var settings: Settings { get }
  func saveSettings(_ settings: Settings)
}

class DefaultSettingsService: SettingsService {

  var settings: Settings

  private let defaultsService: DefaultsService

  init(defaultsService: DefaultsService) {
    self.defaultsService = defaultsService
    self.settings = Self.getSettings(from: defaultsService)
  }
  
  func saveSettings(_ settings: Settings) {
    defaultsService.setItem(Self.convertToPersistenceModel(settings),
                            for: .settingsDetail)
    self.settings = settings
  }
}

// MARK: - Helpers

extension DefaultSettingsService {

  static func getSettings(from defaultsService: DefaultsService) -> Settings {
    if let savedSettings: SettingsPersistenceModel = defaultsService.retrieveItem(for: .settingsDetail) {
      return convertFromPersistenceModel(savedSettings)
    }
    let newSettings = Settings()
    defaultsService.setItem(convertToPersistenceModel(newSettings),
                            for: .settingsDetail)

    return newSettings
  }

  static func convertToPersistenceModel(_ settings: Settings) -> SettingsPersistenceModel {
    .init(isDarkModeEnabled: settings.isDarkModeEnabled)
  }

  static func convertFromPersistenceModel(_ settings: SettingsPersistenceModel) -> Settings {
    .init(isDarkModeEnabled: settings.isDarkModeEnabled)
  }
}

// MARK: - Assembly

final class SettingsServiceAssembly {
  static let shared: SettingsService = DefaultSettingsService(defaultsService: DefaultsServiceAssembly.standard)
}
