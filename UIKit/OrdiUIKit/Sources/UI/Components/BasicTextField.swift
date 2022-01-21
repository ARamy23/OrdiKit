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
//  BasicTextField.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 10/1/20.
//  Copyright © 2020 Ahmed Ramy. All rights reserved.
//

import UIKit.UIFont
import UIKit.UIImage


public protocol TextFieldComponentUI where Self: UIView {
  var state: UITextField.State! { get set }
  var placeholder: String? { get set }
  var text: String? { get set }
  var keyboardType: UIKeyboardType! { get set }
  var isSecureEntry: Bool! { get set }
  var leadingIconImage: UIImage? { get set }
  var trailingIconImage: UIImage? { get set }
  var onInput: ((String?) -> Void)? { get set }
  var onLeadingIconTap: VoidCallback? { get set }
  var onTrailingIconTap: VoidCallback? { get set }
}

class BasicTextField: UIView, TextFieldComponentUI {
  
  var state: UITextField.State! = .inactive {
    didSet {
      updateState()
    }
  }
  
  var placeholder: String? {
    didSet {
      self.textField.attributedPlaceholder = NSAttributedStringBuilder()
        .add(text: placeholder ?? "")
        .add(foregroundColor: Asset.Colors.Primary.primaryDefault.color)
        .build()
    }
  }
  
  var text: String? {
    didSet {
      self.textField.text = text
    }
  }
  
  var keyboardType: UIKeyboardType! {
    didSet {
      self.textField.keyboardType = keyboardType
      if keyboardType == .emailAddress {
        respectsLanguageSemantics = false
      }
    }
  }
  
  var isSecureEntry: Bool! {
    didSet {
      self.textField.isSecureTextEntry = isSecureEntry
    }
  }
  
  var trailingIconImage: UIImage? {
    didSet {
      updateState()
    }
  }
  
  var leadingIconImage: UIImage? {
    didSet {
      updateState()
    }
  }
  
  var onLeadingIconTap: VoidCallback? {
    didSet {
      updateState()
    }
  }
  
  var onTrailingIconTap: VoidCallback? {
    didSet {
      updateState()
    }
  }
  
  var respectsLanguageSemantics: Bool = true {
    didSet {
      guard !respectsLanguageSemantics, self.textField.textAlignment != .center else { return }
      self.textField.textAlignment = .left
    }
  }
  
  var returnAction: VoidCallback?
  
  var onInput: ((String?) -> Void)?
  
  let borderView = UIView().then {
    $0.backgroundColor = Asset.Colors.Primary.primaryDefault.color
    $0.borderWidth = Dimensions.Fields.TextFields.borderWidth
    $0.borderColor = Asset.Colors.Primary.primaryDefault.color
    $0.cornerRadius = Dimensions.Fields.TextFields.cornerRadius
  }
  
  let textField = UITextField().then {
    $0.borderStyle = .none
    $0.setPlaceHolderTextColor(Asset.Colors.Primary.primaryDefault.color)
    $0.font = .pBody
    $0.textColor = Asset.Colors.Primary.primaryDefault.color
  }
  
  let stackView = UIStackView().then {
    $0.alignment = .fill
    $0.axis = .vertical
    $0.distribution = .fill
    $0.spacing = 8
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    initialize()
  }
  
  func updateState() {
    switch state {
    case .inactive, .focused:
      borderView.borderColor = Asset.Colors.Primary.primaryDefault.color
      let direction: UITextField.Direction = UserService.shared.language.value == .arabic ? .left : .right
      guard let desiredImage = direction == .right ? trailingIconImage : leadingIconImage else { return }
      let desiredAction = direction == .right ? onTrailingIconTap : onLeadingIconTap
      textField.icon(direction: direction, image: desiredImage,
                     tintColor: Asset.Colors.Primary.primaryDefault.color,
                     action: desiredAction)
    case .disabled:
      // TODO: - Implement if needed
      break
    
    default:
      break
    }
  }
}

private extension BasicTextField {
  func initialize() {
    setupViews()
    setupConstraints()
    updateState()
  }
  
  func setupViews() {
    self.backgroundColor = .clear
    textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    textField.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
    textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEndOnExit)
    textField.delegate = self
    addSubview(stackView)
    
    stackView.addArrangedSubview(borderView)
    
    borderView.addSubview(textField)
  }
  
  func setupConstraints() {
    stackView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    textField.snp.makeConstraints { (make) in
      make.top.bottom.equalToSuperview().inset(8)
      make.leading.trailing.equalToSuperview().inset(14)
    }
  }
  
  @objc func textDidChange() {
    onInput?(textField.text)
  }
  
  @objc func editingDidBegin() {
    state = .focused
  }
  
  @objc func editingDidEnd() {
    state = .inactive
  }
}

extension BasicTextField: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    returnAction?()
    return true
  }
}
