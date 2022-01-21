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
//  Button.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 10/2/20.
//  Copyright © 2020 Ahmed Ramy. All rights reserved.
//

import UIKit

open class Button: UIButton {
  public enum TypeOfButton {
    case text(_ text: String, style: ButtonStyle)
    case icon(_ icon: UIImage, style: ButtonStyle)
    case textWithLeadingIcon(_ text: String, icon: UIImage, style: ButtonStyle)
    case textWithTrailingIcon(_ text: String, icon: UIImage, style: ButtonStyle)
    
    var style: ButtonStyle? {
      switch self {
      case let .text(_, style: style),
           let .textWithLeadingIcon(_, icon: _, style: style),
           let .textWithTrailingIcon(_, icon: _, style: style),
           let .icon(_, style: style):
        return style
      }
    }
  }

  private enum Direction {
    case leading
    case trailing
  }

  public var type: TypeOfButton = .text(.empty, style: .primary) {
    didSet {
      updateType()
    }
  }

  open override var isEnabled: Bool {
    didSet {
      updateType()
    }
  }

  open var imageToTitleSpacing: CGFloat {
    return 8
  }

  var extraContentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
  open override var contentEdgeInsets: UIEdgeInsets {
    get {
      return super.contentEdgeInsets
    }
    set {
      super.contentEdgeInsets = newValue
      extraContentEdgeInsets = newValue
    }
  }

  var extraImageEdgeInsets: UIEdgeInsets = .zero
  open override var imageEdgeInsets: UIEdgeInsets {
    get {
      return super.imageEdgeInsets
    }
    set {
      super.imageEdgeInsets = newValue
      extraImageEdgeInsets = newValue
    }
  }

  var extraTitleEdgeInsets: UIEdgeInsets = .zero
  open override var titleEdgeInsets: UIEdgeInsets {
    get {
      return super.titleEdgeInsets
    }
    set {
      super.titleEdgeInsets = newValue
      extraTitleEdgeInsets = newValue
    }
  }

  public init(type: TypeOfButton) {
    self.type = type
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

  open override func layoutSubviews() {
    if let imageSize = imageView?.image?.size,
      let font = titleLabel?.font,
      let textSize = titleLabel?.attributedText?.size() ?? titleLabel?.text?
      .size(withAttributes: [NSAttributedString.Key.font: font]) {
      var _imageEdgeInsets = UIEdgeInsets.zero
      var _titleEdgeInsets = UIEdgeInsets.zero
      var _contentEdgeInsets = UIEdgeInsets.zero

      let halfImageToTitleSpacing = imageToTitleSpacing / 2.0

      func adjustLeftSpacing() {
        _imageEdgeInsets.left = -halfImageToTitleSpacing
        _imageEdgeInsets.right = halfImageToTitleSpacing
        _titleEdgeInsets.left = halfImageToTitleSpacing
        _titleEdgeInsets.right = -halfImageToTitleSpacing
        _contentEdgeInsets.left = halfImageToTitleSpacing
        _contentEdgeInsets.right = halfImageToTitleSpacing
      }

      func adjustRightSpacing() {
        _imageEdgeInsets.left = textSize.width + halfImageToTitleSpacing
        _imageEdgeInsets.right = -textSize.width - halfImageToTitleSpacing
        _titleEdgeInsets.left = -imageSize.width - halfImageToTitleSpacing
        _titleEdgeInsets.right = imageSize.width + halfImageToTitleSpacing
        _contentEdgeInsets.left = halfImageToTitleSpacing
        _contentEdgeInsets.right = halfImageToTitleSpacing
      }

      switch type {
      case .text, .icon:
        _imageEdgeInsets = .zero
        _titleEdgeInsets = .zero
        _contentEdgeInsets = .zero

      case .textWithLeadingIcon:
        if UserService.shared.language.value.isRTLLanguage {
          semanticContentAttribute = .forceRightToLeft
        } else {
          semanticContentAttribute = .forceLeftToRight
        }

      case .textWithTrailingIcon:
        if UserService.shared.language.value.isRTLLanguage {
          semanticContentAttribute = .forceLeftToRight
        } else {
          semanticContentAttribute = .forceRightToLeft
        }
      }

      _contentEdgeInsets.top += extraContentEdgeInsets.top
      _contentEdgeInsets.bottom += extraContentEdgeInsets.bottom
      _contentEdgeInsets.left += extraContentEdgeInsets.left
      _contentEdgeInsets.right += extraContentEdgeInsets.right

      _imageEdgeInsets.top += extraImageEdgeInsets.top
      _imageEdgeInsets.bottom += extraImageEdgeInsets.bottom
      _imageEdgeInsets.left += extraImageEdgeInsets.left
      _imageEdgeInsets.right += extraImageEdgeInsets.right

      _titleEdgeInsets.top += extraTitleEdgeInsets.top
      _titleEdgeInsets.bottom += extraTitleEdgeInsets.bottom
      _titleEdgeInsets.left += extraTitleEdgeInsets.left
      _titleEdgeInsets.right += extraTitleEdgeInsets.right

      super.imageEdgeInsets = _imageEdgeInsets
      super.titleEdgeInsets = _titleEdgeInsets
      super.contentEdgeInsets = _contentEdgeInsets

    } else {
      super.imageEdgeInsets = extraImageEdgeInsets
      super.titleEdgeInsets = extraTitleEdgeInsets
      super.contentEdgeInsets = extraContentEdgeInsets
    }

    super.layoutSubviews()
  }
}

// MARK: - Private

internal extension Button {
  func initialize() {
    contentVerticalAlignment = .fill
    contentHorizontalAlignment = .center
    titleLabel?.textAlignment = UILocalization.shared.textAlignment
    setTitle(nil, for: .normal)
    layer.cornerRadius = Dimensions.Buttons.cornerRadius
    layer.masksToBounds = true
    imageView?.contentMode = .scaleAspectFit
    adjustsImageWhenDisabled = false
    tintAdjustmentMode = .normal
    updateType()
    snp.makeConstraints { $0.height.equalTo(Dimensions.Buttons.height).priority(.medium) }
  }

  func updateType() {
    switch type {
    case let .text(text, style):
      let desiredStyle = isEnabled ? style : .disabled
      setText(text, buttonStyle: desiredStyle)

    case let .icon(icon, style):
      setIcon(icon, tintColor: style.iconColor, farEdge: style.shouldPutIconInFarEdge)

    case let .textWithLeadingIcon(text, icon, style):
      let desiredStyle = isEnabled ? style : .disabled
      setText(text, buttonStyle: desiredStyle)
      setIcon(icon, tintColor: desiredStyle.iconColor, farEdge: style.shouldPutIconInFarEdge)

    case let .textWithTrailingIcon(text, icon, style):
      let desiredStyle = isEnabled ? style : .disabled
      setText(text, buttonStyle: desiredStyle)
      setIcon(icon, tintColor: desiredStyle.iconColor, farEdge: style.shouldPutIconInFarEdge)
    }
    let desiredStyle = isEnabled ? type.style : .disabled
    self.backgroundColor = desiredStyle?.backgroundColor
    self.borderColor = desiredStyle?.borderColor
    self.borderWidth = desiredStyle?.borderWidth ?? 0.0
  }

  func setText(_ text: String, buttonStyle: ButtonStyle) {
    UIView.performWithoutAnimation {
      setAttributedTitle(NSAttributedStringBuilder()
        .add(text: text)
        .add(foregroundColor: buttonStyle.textColor)
        .build(), for: .normal)
    }
  }

  func setIcon(_ icon: UIImage, tintColor: UIColor?, farEdge: Bool) {
    guard let tintColor = tintColor else { return }
    UIView.performWithoutAnimation {
      self.setImage(icon.withTintColor(tintColor), for: .normal)
      self.tintColor = tintColor
      
      guard farEdge else { return }
      self.translatesAutoresizingMaskIntoConstraints = false
      self.imageView?.translatesAutoresizingMaskIntoConstraints = false
      
      self.imageView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0).isActive = true
      self.imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
    }
  }
}
