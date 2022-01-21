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
//  NSAttributedStringBuilder.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 10/2/20.
//  Copyright © 2020 Ahmed Ramy. All rights reserved.
//

import UIKit

public class NSAttributedStringBuilder {
  private var attributedString = NSMutableAttributedString()
  
  private func wholeString() -> NSRange {
    .init(location: 0, length: attributedString.string.utf16.count)
  }
  
  @discardableResult
  public func add(text: String)-> NSAttributedStringBuilder {
    attributedString.append(NSAttributedString(string: text))
    return self
  }
  
  @discardableResult
  public func add(foregroundColor: UIColor)-> NSAttributedStringBuilder {
    attributedString.addAttribute(.foregroundColor, value: foregroundColor, range: wholeString())
    return self
  }
  
  @discardableResult
  public func add(foregroundColor: UIColor, for string: String)-> NSAttributedStringBuilder {
    guard let substringRange = attributedString.string.range(of: string) else { return self }
    let range = NSRange(substringRange, in: attributedString.string)
    attributedString.addAttribute(.foregroundColor, value: foregroundColor, range: range)
    return self
  }
  
  @discardableResult
  public func add(font: ARFont, for string: String) -> NSAttributedStringBuilder {
    guard let substringRange = attributedString.string.range(of: string) else { return self }
    let range = NSRange(substringRange, in: attributedString.string)
    attributedString.addAttribute(.font, value: font, range: range)
    let style = NSMutableParagraphStyle().then {
      $0.lineHeightMultiple = font.metrics.lineHeight
      $0.minimumLineHeight = font.metrics.lineHeight
      $0.maximumLineHeight = font.metrics.lineHeight
      $0.lineSpacing = font.metrics.letterSpacing
    }
    attributedString.addAttribute(.paragraphStyle, value: style, range: range)
    return self
  }
  
  @discardableResult
  public func add(font: ARFont) -> NSAttributedStringBuilder {
    let range = wholeString()
    attributedString.addAttribute(.font, value: font.accessibleFont, range: range)
    let style = NSMutableParagraphStyle().then {
      $0.lineHeightMultiple = font.accessibleLineHeight
      $0.minimumLineHeight = font.accessibleLineHeight
      $0.maximumLineHeight = font.accessibleLineHeight
      $0.lineSpacing = font.accessibleLetterSpacing
    }
    attributedString.addAttribute(.paragraphStyle, value: style, range: range)
    return self
  }
  
  @discardableResult
  public func add(underlineFor string: String)-> NSAttributedStringBuilder {
    guard let substringRange = attributedString.string.range(of: string) else { return self }
    let range = NSRange(substringRange, in: attributedString.string)
    attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single, range: range)
    return self
  }
  
  public func build() -> NSAttributedString {
    attributedString.attributedSubstring(from: wholeString())
  }
}
