//
//  AppConfigurations.swift
//  Products
//
//  Created by Dmytro Nosulich on 01.06.25.
//

import Foundation

class AppConfigurations {

  static var shared = AppConfigurations()

  private init() {}

  var locale: Locale = .current
}
