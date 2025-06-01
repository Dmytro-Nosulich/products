//
//  Settings.swift
//  Products
//
//  Created by Dmytro Nosulich on 28.05.25.
//

import Foundation

@Observable
class Settings: Equatable {

  var isDarkModeEnabled: Bool

  init(isDarkModeEnabled: Bool = false) {
    self.isDarkModeEnabled = isDarkModeEnabled
  }

  static func == (lhs: Settings, rhs: Settings) -> Bool {
    lhs.isDarkModeEnabled == rhs.isDarkModeEnabled
  }
}
