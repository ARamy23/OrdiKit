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
//  Label.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 11/17/20.
//  Copyright © 2020 Ahmed Ramy. All rights reserved.
//

import UIKit

@IBDesignable
open class Label: UILabel {
  @objc open dynamic var edgeInsets = UIEdgeInsets.zero {
    didSet {
      setNeedsLayout()
      invalidateIntrinsicContentSize()
    }
  }
  
  var customTextColor: UIColor? {
    didSet {
      text(text)
    }
  }
  
  var customFont: ARFont? {
    didSet {
      text(text)
    }
  }
  
  var customAttributedString: NSAttributedString? {
    didSet {
      text(text)
    }
  }
  
  // MARK: - Initializers

  public init(viewModel: UIManager.LabelViewModel) {
    self.customTextColor = viewModel.color
    self.customFont = viewModel.font
    super.init(frame: .zero)
    initialize()
    hidableText(viewModel.text.emptyIfNil)
  }
  
  public init(font: ARFont, color: UIColor) {
    self.customTextColor = color
    self.customFont = font
    super.init(frame: .zero)
    initialize()
  }
  
  public init(customAttributedString: NSAttributedString) {
    self.customAttributedString = customAttributedString
    super.init(frame: .zero)
    initialize()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    initialize()
  }

  override open func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: edgeInsets))
  }

  override open var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(width: size.width + edgeInsets.left + edgeInsets.right,
                  height: size.height + edgeInsets.top + edgeInsets.bottom)
  }
  
  public func boldify(text: [String]) {
    guard let usedAttributedText = self.attributedText else { return }
    let newAttributedText = NSMutableAttributedString(attributedString: usedAttributedText)
    text.forEach {
      newAttributedText.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: self.font.pointSize, weight: .black)], range: (usedAttributedText.string as NSString).range(of: $0 as String))
    }
    self.attributedText = newAttributedText
  }
}

private extension Label {
  func initialize() {
    numberOfLines = 0
    lineBreakMode = .byWordWrapping
    textAlignment = UILocalization.shared.textAlignment
    backgroundColor = .clear
    adjustsFontForContentSizeCategory = true
  }
}

public extension Label {
  func text(_ text: String?) {
    // Clear text
    self.text = nil

    if let text = text, let customFont = customFont, let customTextColor = customTextColor {
      attributedText = NSAttributedStringBuilder()
        .add(text: text)
        .add(font: customFont)
        .add(foregroundColor: customTextColor)
        .build()
    } else if let customAttributedString = customAttributedString {
      attributedText = customAttributedString
    } else {
      attributedText = nil
    }
  }

  func hidableText(_ text: String?) {
    guard let text = text else {
      isHidden = true
      return
    }
    isHidden = false
    self.text(text)
  }
}
