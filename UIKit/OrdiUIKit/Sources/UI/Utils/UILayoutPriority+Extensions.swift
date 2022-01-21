//
//  UILayoutPriority+Extensions.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 10/4/20.
//  Copyright © 2020 Ahmed Ramy. All rights reserved.
//

import UIKit

public extension UILayoutPriority {

  static func rawValue(_ value: Float) -> UILayoutPriority  {
    return UILayoutPriority(value)
  }
}
