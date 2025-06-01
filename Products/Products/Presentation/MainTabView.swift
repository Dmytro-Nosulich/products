//
//  MainTabView.swift
//  Products
//
//  Created by Dmytro Nosulich on 28.05.25.
//

import SwiftUI

struct MainTabView: View {
  
  var body: some View {
    TabView {
      Tab("Products", systemImage: "line.3.horizontal") {
        ProductListView(viewModel: .init(dependencyContainer: .init()))
      }

      Tab("Settings", systemImage: "gear") {
        SettingsView(viewModel: .init(dependencyContainer: .init()))
      }
    }
  }
}

#Preview {
  MainTabView()
}
