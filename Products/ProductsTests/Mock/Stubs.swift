//
//  Stubs.swift
//  ProductsTests
//
//  Created by Dmytro Nosulich on 31.05.25.
//

import Foundation

// MARK: Stubs for Swift types

public extension Bool {
  static let stub: Bool = false
}

public extension Int {
  static let stub = -1
}

public extension String {
  static let stub = "<{a stub that's very unlikely to be alike a real value}>"
}

public extension Date {
  static let stub = Date(timeIntervalSinceReferenceDate: 0)
}

public extension Array {
  static var stub: Self { [] }
}

public extension Dictionary {
  static var stub: Self { [:] }
}

public extension URL {
  static var stub: Self { NSURL() as URL }
}
