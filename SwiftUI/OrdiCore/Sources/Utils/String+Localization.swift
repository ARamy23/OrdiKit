//
//  String+Localization.swift
//  Al Najd
//
//  Created by Ahmed Ramy on 21/01/2022.
//

import Foundation

public extension String {
  /// SwifterSwift: Returns a localized string, with an optional comment for translators.
  ///
  ///        "Hello world".localized -> Hallo Welt
  ///
  var localized: String {
      return NSLocalizedString(self, tableName: "Localizables", bundle: .main, comment: "")
  }
  
  func localized(arguments: CVarArg...) -> String {
    return String(format: self.localized, arguments: arguments)
  }
}
