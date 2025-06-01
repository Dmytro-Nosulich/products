//
//  Settings.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 31.05.25.
//

import Foundation

extension Settings {
  public static func stub(
    isDarkModeEnabled: Bool = .stub
  ) -> Settings {
    Settings(isDarkModeEnabled: isDarkModeEnabled)
  }
}
