//
//  SettingsServiceTests.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 01.06.25.
//

import Testing

struct SettingsServiceTests {

  typealias SUT = DefaultSettingsService
  var defaultsService = DefaultsServiceMock()

  func makeSUT() -> DefaultSettingsService {
    DefaultSettingsService(defaultsService: defaultsService)
  }

  @Test func settingsWhenNoSavedModel() throws {
    // give
    let sut = makeSUT()

    // then
    let savedSettings = try #require(defaultsService.setItems[.settingsDetail] as? SettingsPersistenceModel)
    #expect(sut.settings == Settings())
    #expect(defaultsService.invocations == [
      .retrieveItem(.settingsDetail)
    ])
    #expect(savedSettings == SettingsPersistenceModel(isDarkModeEnabled: false))
  }

  @Test func settingsWhenHasSavedModel() {
    // give
    defaultsService.itemsToRetrieve[.settingsDetail] = SettingsPersistenceModel(isDarkModeEnabled: true)
    let sut = makeSUT()

    // then
    #expect(sut.settings == Settings(isDarkModeEnabled: true))
    #expect(defaultsService.invocations == [
      .retrieveItem(.settingsDetail)
    ])
  }

  @Test func saveSettings() throws {
    // give
    let sut = makeSUT()
    let newSettings = Settings(isDarkModeEnabled: true)

    // when
    sut.saveSettings(newSettings)

    // then
    let savedSettings = try #require(defaultsService.setItems[.settingsDetail] as? SettingsPersistenceModel)
    #expect(sut.settings == Settings(isDarkModeEnabled: true))
    #expect(defaultsService.invocations == [
      .retrieveItem(.settingsDetail)
    ])
    #expect(savedSettings == SettingsPersistenceModel(isDarkModeEnabled: true))
  }

  @Test func convertToPersistenceModel() {
    // given
    let settings = Settings(isDarkModeEnabled: true)

    // when
    let result = SUT.convertToPersistenceModel(settings)

    // then
    #expect(result == SettingsPersistenceModel(isDarkModeEnabled: true))
  }

  @Test func convertFromPersistenceModel() {
    // given
    let settings = SettingsPersistenceModel(isDarkModeEnabled: true)

    // when
    let result = SUT.convertFromPersistenceModel(settings)

    // then
    #expect(result == Settings(isDarkModeEnabled: true))
  }
}
