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
//  Configurations.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 11/16/20.
//  Copyright © 2020 Ahmed Ramy. All rights reserved.
//

import UIKit

public typealias Spacing = Configurations.UI.Spacing
public typealias Pin = Configurations.UI.Pin
public typealias Profile = Configurations.UI.Profile
public typealias FontStyles = Configurations.UI.FontStyles
public typealias DoubleRepresentation = Configurations.Business.DoubleRepresentation
public typealias OTPTimer = Configurations.Business.OTPTimer
public typealias BiometricTimer = Configurations.Business.BiometricTimer
public typealias Fields = Configurations.UI.Fields

public enum Configurations {
  
  public enum Business {
    public enum DoubleRepresentation {
      public static var minimumFractionDigits = 2
    }
    
    public enum OTPTimer {
      public static var interval: Double = 8
    }
    
    public enum BiometricTimer {
      public static var interval: Double = 60 * 5
    }
  }
  
  public enum UI {
    public enum Spacing {
      /// 4
      public static var p05: CGFloat = 4
      /// 8
      public static var p1: CGFloat = 8
      /// 16
      public static var p2: CGFloat = 16
      /// 24
      public static var p3: CGFloat = 24
      
      public static var scrollViewBottomPadding: CGFloat = 65
      
      public enum Specific {
        public static var homeSpacingBetweenHeaderAndContent: CGFloat = 75
      }
    }
    
    public enum Pin {
      public static var length: Int = 6
      public static var interSpace: CGFloat = 5
      public static var borderThickness: CGFloat = 1
      public static var activeBorderThickness: CGFloat = 3
      public static var activeCornerRadius: CGFloat = 8
      public static var cornerRadius: CGFloat = 8
      public static var placeholder: String = "••••••"
      //      public static var font: MPFont = FontFactory.getLocalizedFont(.bold, 15)
    }
    
    public enum QuickLinks {
      public static var height: CGFloat = 80
      public static var iconSize: CGSize = .init(width: 25, height: 25)
    }
    
    public enum TransactionHistories {
      public static var height: CGFloat = 50
    }
    
    public enum Profile {
      public static var pictureSize: CGSize = CGSize(width: 150, height: 150)
    }
    
    public enum RequestFromCard {
      public static var cornerRadius: CGFloat = 16
    }
    
    public enum FontStyles {
      public static var largeTitle: MPFont = FontManager.shared.getSuitableFont(category: .display, scale: .huge, weight: .regular).toUIKitFont()
      public static var title1: MPFont = FontManager.shared.getSuitableFont(category: .display, scale: .large, weight: .regular).toUIKitFont()
      public static var title2: MPFont = FontManager.shared.getSuitableFont(category: .display, scale: .medium, weight: .regular).toUIKitFont()
      public static var title3: MPFont = FontManager.shared.getSuitableFont(category: .display, scale: .small, weight: .regular).toUIKitFont()
      public static var headline: MPFont = FontManager.shared.getSuitableFont(category: .text, scale: .large, weight: .regular).toUIKitFont()
      public static var subheadline: MPFont = FontManager.shared.getSuitableFont(category: .text, scale: .medium, weight: .regular).toUIKitFont()
      public static var body: MPFont = FontManager.shared.getSuitableFont(category: .text, scale: .small, weight: .regular).toUIKitFont()
      public static var callout: MPFont = FontManager.shared.getSuitableFont(category: .text, scale: .xsmall, weight: .regular).toUIKitFont()
      public static var footnote: MPFont = FontManager.shared.getSuitableFont(category: .link, scale: .large, weight: .bold).toUIKitFont()
      public static var caption1: MPFont = FontManager.shared.getSuitableFont(category: .link, scale: .medium, weight: .bold).toUIKitFont()
      public static var caption2: MPFont = FontManager.shared.getSuitableFont(category: .link, scale: .small, weight: .bold).toUIKitFont()
      public static var caption3: MPFont = FontManager.shared.getSuitableFont(category: .link, scale: .xsmall, weight: .bold).toUIKitFont()
    }
    
    public enum Fields {
      public static let cornerRadius: CGFloat = 8
      public static let borderWidth: CGFloat = 1
    }
  }
}
