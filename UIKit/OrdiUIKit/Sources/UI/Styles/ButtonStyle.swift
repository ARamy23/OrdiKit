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
//  ButtonStyle.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 10/2/20.
//  Copyright © 2020 Ahmed Ramy. All rights reserved.
//

import UIKit

public protocol ButtonStyleProtocol: Style {
  var iconColor: UIColor { get }
  var shouldPutIconInFarEdge: Bool { get }
}

public struct ButtonStyle: ButtonStyleProtocol {
  public let textColor: UIColor
  public let backgroundColor: UIColor
  public let iconColor: UIColor
  public let borderColor: UIColor?
  public let borderWidth: CGFloat?
  public let shouldPutIconInFarEdge: Bool
  
  static let primary: ButtonStyle = .init(
    textColor: .mono.offwhite,
    backgroundColor: .primary.default,
    iconColor: .mono.offwhite,
    borderColor: nil,
    borderWidth: nil,
    shouldPutIconInFarEdge: false
  )
  
  static let overlay: ButtonStyle = .init(
    textColor: .clear,
    backgroundColor: .clear,
    iconColor: .clear,
    borderColor: .clear,
    borderWidth: 1,
    shouldPutIconInFarEdge: false
  )
  
  static let settings: ButtonStyle = .init(
    textColor: .mono.offblack,
    backgroundColor: .mono.offwhite,
    iconColor: .clear,
    borderColor: .mono.line,
    borderWidth: 1,
    shouldPutIconInFarEdge: true
  )
  
  static let disabled: ButtonStyle = .init(
    textColor: .mono.offwhite,
    backgroundColor: .mono.placeholder,
    iconColor: .clear,
    borderColor: .clear,
    borderWidth: 1,
    shouldPutIconInFarEdge: true
  )
}
