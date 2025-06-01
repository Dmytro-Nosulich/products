//
//  SettingsViewModelTests.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 01.06.25.
//

import Testing

struct SettingsViewModelTests {

  var settingsService = SettingsServiceMock()

  func makeSUT() -> SettingsViewModel {
    return SettingsViewModel(
      dependencyContainer: .init(
        settingsService: settingsService
      )
    )
  }

  @Test func saveSettings() {
    // given
    let sut = makeSUT()

    // when
    sut.settings.isDarkModeEnabled = true
    sut.saveSettings()

    // then
    #expect([settingsService.settings] == [
      Settings(isDarkModeEnabled: true)
    ])
  }
}
