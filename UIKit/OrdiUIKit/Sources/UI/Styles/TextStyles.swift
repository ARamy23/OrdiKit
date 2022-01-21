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
//  TextStyles.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 10/2/20.
//  Copyright © 2020 Ahmed Ramy. All rights reserved.
//

import Foundation

/// Enum with static fonts that matches HIG's metrics
/// To Check the metrics, u can check the FontManager
public enum TextStyles {
  public static let displayHuge: FontProtocol = FontManager.shared.getSuitableFont(category: .display, scale: .huge, weight: .regular)
  public static let displayLarge: FontProtocol = FontManager.shared.getSuitableFont(category: .display, scale: .large, weight: .regular)
  public static let displayMedium: FontProtocol = FontManager.shared.getSuitableFont(category: .display, scale: .medium, weight: .regular)
  public static let displaySmall: FontProtocol = FontManager.shared.getSuitableFont(category: .display, scale: .small, weight: .regular)
  
  public static let displayHugeBold: FontProtocol = FontManager.shared.getSuitableFont(category: .display, scale: .huge, weight: .bold)
  public static let displayLargeBold: FontProtocol = FontManager.shared.getSuitableFont(category: .display, scale: .large, weight: .bold)
  public static let displayMediumBold: FontProtocol = FontManager.shared.getSuitableFont(category: .display, scale: .medium, weight: .bold)
  public static let displaySmallBold: FontProtocol = FontManager.shared.getSuitableFont(category: .display, scale: .small, weight: .bold)
  
  public static let textHuge: FontProtocol = FontManager.shared.getSuitableFont(category: .text, scale: .huge, weight: .regular)
  public static let textLarge: FontProtocol = FontManager.shared.getSuitableFont(category: .text, scale: .large, weight: .regular)
  public static let textMedium: FontProtocol = FontManager.shared.getSuitableFont(category: .text, scale: .medium, weight: .regular)
  public static let textSmall: FontProtocol = FontManager.shared.getSuitableFont(category: .text, scale: .small, weight: .regular)
  
  public static let linkHuge: FontProtocol = FontManager.shared.getSuitableFont(category: .link, scale: .huge, weight: .bold)
  public static let linkLarge: FontProtocol = FontManager.shared.getSuitableFont(category: .link, scale: .large, weight: .bold)
  public static let linkMedium: FontProtocol = FontManager.shared.getSuitableFont(category: .link, scale: .medium, weight: .bold)
  public static let linkSmall: FontProtocol = FontManager.shared.getSuitableFont(category: .link, scale: .small, weight: .bold)
}
