//
//  SettingsView.swift
//  Products
//
//  Created by Dmytro Nosulich on 28.05.25.
//

import SwiftUI

struct SettingsView: View {

  @State var viewModel: SettingsViewModel

  init(viewModel: SettingsViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    NavigationStack {
      Form {
        HStack {
          Text("Enable Dark Mode:")
          Toggle("", isOn: $viewModel.settings.isDarkModeEnabled)
            .onChange(of: viewModel.settings.isDarkModeEnabled, viewModel.saveSettings)
        }
      }
      .navigationTitle("Settings")
    }
  }
}

#Preview {
  SettingsView(viewModel: .init(dependencyContainer: .init()))
}
