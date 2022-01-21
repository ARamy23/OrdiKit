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
//  FontConfig.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 02/06/2021.
//  Copyright © 2021 RamySDK. All rights reserved.
//

import Foundation

// MARK: - ConfigFonts
public struct ConfigFonts: Codable {
  public let fonts: [ConfigFontsElement]
  public let defaultConfigurations: ConfigFontsDefaultConfigurations
  
  enum CodingKeys: String, CodingKey {
    case fonts = "fonts"
    case defaultConfigurations = "default_configurations"
  }
  
  public init(fonts: [ConfigFontsElement], defaultConfigurations: ConfigFontsDefaultConfigurations) {
    self.fonts = fonts
    self.defaultConfigurations = defaultConfigurations
  }
}

// MARK: - ConfigDefaultConfigurations
public struct ConfigFontsDefaultConfigurations: Codable {
  public let type: String
  public let locale: String
  
  enum CodingKeys: String, CodingKey {
    case type = "type"
    case locale = "locale"
  }
  
  public init(type: String, locale: String) {
    self.type = type
    self.locale = locale
  }
  
  public func sdkFriendlyType() -> FontType {
    .init(string: type)
  }
  
  public func sdkFriendlyLocale() -> FontLocale {
    .init(string: locale)
  }
}

// MARK: - ConfigFont
public struct ConfigFontsElement: Codable {
  public let family: String
  public let locale: String
  public let type: String
  
  enum CodingKeys: String, CodingKey {
    case family = "family"
    case locale = "locale"
    case type = "type"
  }
  
  public init(family: String, locale: String, type: String) {
    self.family = family
    self.locale = locale
    self.type = type
  }
  
  public func sdkFriendlyType() -> FontType {
    .init(string: type)
  }
  
  public func sdkFriendlyLocale() -> FontLocale {
    .init(string: locale)
  }
  
  public func toSDKFont() -> FontDetails {
    FontDetails(name: self.family, fontLocale: sdkFriendlyLocale(), fontType: sdkFriendlyType())
  }
}
