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
//  Colors.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 01/06/2021.
//  Copyright © 2021 RamySDK. All rights reserved.
//

import UIKit

public protocol Colorable {
  var primary: BrandColor { get }
  var secondary: BrandColor { get }
  var monochromatic: Monochromatic { get }
  var transparency: Transparency { get }
  var success: BrandColor { get }
  var warning: BrandColor { get }
  var danger: BrandColor { get }
  var info: BrandColor { get }
}

public protocol BrandColor {
  var `default`: UIColor { get }
  var dark: UIColor { get }
  var darkMode: UIColor { get }
  var light: UIColor { get }
  var background: UIColor { get }
}

public protocol Monochromatic {
  var offblack: UIColor { get }
  var ash: UIColor { get }
  var body: UIColor { get }
  var label: UIColor { get }
  var placeholder: UIColor { get }
  var line: UIColor { get }
  var input: UIColor { get }
  var background: UIColor { get }
  var offwhite: UIColor { get }
}

public protocol Transparency {
  var light: UIColor { get }
  var dark: UIColor { get }
  
  func light(by percentage: CGFloat) -> UIColor
  func dark(by percentage: CGFloat) -> UIColor
}

public struct PrimaryPalette: BrandColor {
  public var `default`: UIColor = .init(named: "Primary.default")!
  public var dark: UIColor  = .init(named: "Primary.dark")!
  public var darkMode: UIColor = .init(named: "Primary.darkMode")!
  public var light: UIColor = .init(named: "Primary.light")!
  public var background: UIColor = .init(named: "Primary.background")!
}

public struct SecondaryPalette: BrandColor {
  public var `default`: UIColor = .init(named: "Secondary.default")!
  public var dark: UIColor  = .init(named: "Secondary.dark")!
  public var darkMode: UIColor = .init(named: "Secondary.darkMode")!
  public var light: UIColor = .init(named: "Secondary.light")!
  public var background: UIColor = .init(named: "Secondary.background")!
}

public struct SuccessPalette: BrandColor {
  public var `default`: UIColor = .init(named: "Success.default")!
  public var dark: UIColor  = .init(named: "Success.dark")!
  public var darkMode: UIColor = .init(named: "Success.darkMode")!
  public var light: UIColor = .init(named: "Success.light")!
  public var background: UIColor = .init(named: "Success.background")!
}

public struct WarningPalette: BrandColor {
  public var `default`: UIColor = .init(named: "Warning.default")!
  public var dark: UIColor  = .init(named: "Warning.dark")!
  public var darkMode: UIColor = .init(named: "Warning.darkMode")!
  public var light: UIColor = .init(named: "Warning.light")!
  public var background: UIColor = .init(named: "Warning.background")!
}

public struct DangerPalette: BrandColor {
  public var `default`: UIColor = .init(named: "Danger.default")!
  public var dark: UIColor  = .init(named: "Danger.dark")!
  public var darkMode: UIColor = .init(named: "Danger.darkMode")!
  public var light: UIColor = .init(named: "Danger.light")!
  public var background: UIColor = .init(named: "Danger.background")!
}

public struct InfoPalette: BrandColor {
  public var `default`: UIColor = .init(named: "Info.default")!
  public var dark: UIColor  = .init(named: "Info.dark")!
  public var darkMode: UIColor = .init(named: "Info.darkMode")!
  public var light: UIColor = .init(named: "Info.light")!
  public var background: UIColor = .init(named: "Info.background")!
}

public struct TransparencyPalette: Transparency {
  public var light: UIColor = .init(named: "Transparency.light.full")!
  public var dark: UIColor = .init(named: "Transparency.dark.full")!
  
  public func light(by percentage: CGFloat) -> UIColor {
    light.withAlphaComponent(percentage / 100)
  }
  
  public func dark(by percentage: CGFloat) -> UIColor {
    dark.withAlphaComponent(percentage / 100)
  }
}

public struct MonochromaticPalette: Monochromatic {
  public var offblack: UIColor = .init(named: "Monochromatic.offblack")!
  public var ash: UIColor = .init(named: "Monochromatic.offblack")!
  public var body: UIColor = .init(named: "Monochromatic.body")!
  public var label: UIColor = .init(named: "Monochromatic.label")!
  public var placeholder: UIColor = .init(named: "Monochromatic.placeholder")!
  public var line: UIColor = .init(named: "Monochromatic.line")!
  public var input: UIColor = .init(named: "Monochromatic.input")!
  public var background: UIColor = .init(named: "Monochromatic.background")!
  public var offwhite: UIColor = .init(named: "Monochromatic.offwhite")!
}

public enum UIManager { }

// MARK: - Button
public extension UIManager {
  struct LabelViewModel {
    let font: ARFont
    let text: String?
    let color: UIColor
    
    // Custom Coloring
    public init(
      _ font: ARFont,
      _ text: String,
      color: UIColor
    ) {
      self.font = font
      self.text = text
      self.color = color
    }
    
    // Design System Conforming
    public init(
      _ font: ARFont,
      _ text: String,
      _ type: LabelType
    ) {
      self.font = font
      self.text = text
      self.color = type.color
    }
  }
}

public extension UIManager.LabelViewModel {
  enum LabelType {
    case title
    case body
    case link
    case caption
    
    var color: UIColor {
      switch self {
      case .title:
        return .mono.offblack
      case .body:
        return .mono.body
      case .link,
           .caption:
        return .mono.label
      }
    }
  }
}

// MARK: - Button
public extension UIManager {
  
  struct ButtonViewModel {
    let type: ButtonType
    let size: Size
    let radius: Radius
    let content: ContentType
    let layout: ContentLayout
    
    public init(
      _ type: ButtonType,
      _ size: Size,
      _ radius: Radius,
      _ content: ContentType,
      _ layout: ContentLayout
    ) {
      self.type = type
      self.size = size
      self.radius = radius
      self.content = content
      self.layout = layout
    }
  }
}

public extension UIManager.ButtonViewModel {
  enum Radius {
    case pill
    case semiRounded
    case circle
  }
  
  enum Size {
    case huge
    case large
    case medium
    case small
    
    func getSize() -> CGFloat {
      switch self {
      case .huge: return 72
      case .large: return 64
      case .medium: return 56
      case .small: return 40
      }
    }
    
    func getRadius(from radius: Radius) -> CGFloat {
      switch (self, radius) {
      case (.huge, .semiRounded):
        return 16
      case (.large, .semiRounded),
           (.medium, .semiRounded):
        return 12
      case (.small, .semiRounded):
        return 8
      case (_, .pill),
           (_, .circle):
        return getSize() / 2
      }
    }
  }
  
  enum ButtonType {
    case primary
    case secondary
    case subtle
    case text
  }
  
  enum ContentType {
    case text(String)
    case icon(VisualContent)
  }
  
  enum ContentLayout {
    case center
    case leading
    case trailing
  }
  
  enum State {
    case `default`
    case highlighted
    case focused
    case hover
    case pressed
  }
}
