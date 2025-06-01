//
//  SettingsViewModel.swift
//  Products
//
//  Created by Dmytro Nosulich on 29.05.25.
//

import Foundation

class SettingsViewModel {

  var settings: Settings

  private let settingsService: SettingsService

  init(dependencyContainer: DependencyContainer) {
    self.settingsService = dependencyContainer.settingsService
    self.settings = dependencyContainer.settingsService.settings
  }

  // MARK: - Public methods

  func saveSettings() {
    settingsService.saveSettings(settings)
  }
}

// MARK: - DependencyContainer

extension SettingsViewModel {

  struct DependencyContainer {
    let settingsService: SettingsService

    init(
      settingsService: SettingsService = SettingsServiceAssembly.shared
    ) {
      self.settingsService = settingsService
    }
  }
}
