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
//  Dimensions.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 10/2/20.
//  Copyright © 2020 Ahmed Ramy. All rights reserved.
//

import UIKit

enum Dimensions {
  enum Buttons {
    public static let cornerRadius: CGFloat = 16
    public static let height: CGFloat = 45
    
    enum MultipleOptionsButtons {
      public static let cornerRadius: CGFloat = 8
    }
    
    enum AccountSelectionRowButtons {
      public static let height: CGFloat = 116
    }
  }
  
  enum IconSizes {
    public static let p1: CGFloat = 12
    public static let p2: CGFloat = 18
    public static let p3: CGFloat = 24
  }
  
  enum Fields {
    enum TextFields {
      public static let height: CGFloat = 44
      public static let cornerRadius: CGFloat = 8
      public static let borderWidth: CGFloat = 1
      public static let accessorySize = CGSize(width: 44, height: 44)
      public static let iconSize = CGSize(width: 24, height: 24)
    }
    
    enum TextViews {
      public static let height: CGFloat = 150
      public static let cornerRadius: CGFloat = 8
      public static let borderWidth: CGFloat = 1
    }
  }
  
  enum Separator {
    public static let height: CGFloat = 1
    public static let cornerRadius: CGFloat = 0
  }
  
  enum Avatar {
    public static let size = CGSize(width: 100, height: 100)
    public static let borderWidth: CGFloat = 1
  }
  
  enum ImageSlider {
    static let imageSliderItemSize: CGSize = CGSize(width: Device.width, height: Device.height * 0.8)
  }
  
  enum Device {
    
    public static var size: CGSize = .init(width: width, height: height)
    
    /// If the current device is iPad, it checks the viewController first and uses its frame rater than the Screen's since that some times messes up the UI
    public static var width: CGFloat {
      if UIDevice.isPad {
        return UIApplication.topViewController()?.view.frame.width ?? UIScreen.main.bounds.width
      } else {
        return UIScreen.main.bounds.width
      }
    }
    
    /// If the current device is iPad, it checks the viewController first and uses its frame rater than the Screen's since that some times messes up the UI
    public static var height: CGFloat {
      if UIDevice.isPad {
        return UIApplication.topViewController()?.view.frame.height ?? UIScreen.main.bounds.height
      } else {
        return UIScreen.main.bounds.height
      }
    }
  }
}
