//
// This is free and unencumbered software released into the public domain.
// 
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.
//
// In jurisdictions that recognize copyright laws, the author or authors
// of this software dedicate any and all copyright interest in the
// software to the public domain. We make this dedication for the benefit
// of the public at large and to the detriment of our heirs and
// successors. We intend this dedication to be an overt act of
// relinquishment in perpetuity of all present and future rights to this
// software under copyright law.
// 
// THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
// OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
// 
// For more information, please refer to <https://unlicense.org>
//
//
//  Theme.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 31/05/2021.
//  Copyright © 2021 RamySDK. All rights reserved.
//

import UIKit

public protocol RTheme: Colorable, FontCustomizable { }

public struct DefaultTheme: RTheme {
  public var primary: BrandColor = PrimaryPalette()
  public var secondary: BrandColor = SecondaryPalette()
  public var monochromatic: Monochromatic = MonochromaticPalette()
  public var transparency: Transparency = TransparencyPalette()
  public var success: BrandColor = SuccessPalette()
  public var warning: BrandColor = WarningPalette()
  public var danger: BrandColor = DangerPalette()
  public var info: BrandColor = InfoPalette()
  
  public func setupFont() -> FontManager {
    guard let url = Bundle.main.url(forResource: "fonts", withExtension: "json") else { fatalError() }
    do {
      let data = try Data(contentsOf: url)
      let configs = try JSONDecoder().decode(ConfigFonts.self, from: data)
      return FontManager(
        configuration: FontManager.Configuration(
          fontsLocale: configs.defaultConfigurations.sdkFriendlyLocale(),
          fontsType: configs.defaultConfigurations.sdkFriendlyType(),
          availableFonts: configs.fonts.map { $0.toSDKFont() }
        )
      )
    } catch {
      LoggersManager.error(error.asARError())
      fatalError(error.localizedDescription)
    }
  }
}

public final class ThemeManager {
  public var selectedTheme: RTheme = DefaultTheme()
  public var supportedThemes: [RTheme] = [DefaultTheme()]
  public static var shared: ThemeManager = .init()
  
  public init() {
    setup()
  }
  
  public func setup() {
    FontManager.shared = selectedTheme.setupFont()
  }
}

public extension UIColor {
  static var primary: BrandColor { ThemeManager.shared.selectedTheme.secondary }
  static var secondary: BrandColor { ThemeManager.shared.selectedTheme.primary }
  static var mono: Monochromatic { ThemeManager.shared.selectedTheme.monochromatic }
  static var transparency: Transparency { ThemeManager.shared.selectedTheme.transparency }
  static var success: BrandColor { ThemeManager.shared.selectedTheme.success }
  static var warning: BrandColor { ThemeManager.shared.selectedTheme.warning }
  static var danger: BrandColor { ThemeManager.shared.selectedTheme.danger }
  static var info: BrandColor { ThemeManager.shared.selectedTheme.info }
}
