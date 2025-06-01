//
//  ProductsApp.swift
//  Products
//
//  Created by Dmytro Nosulich on 28.05.25.
//

import SwiftUI

@main
struct ProductsApp: App {

  @State private var settings = SettingsServiceAssembly.shared.settings

  var body: some Scene {
    WindowGroup {
      MainTabView()
        .preferredColorScheme(settings.isDarkModeEnabled ? .dark : .light)
    }
  }
}
