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
//  PhoneNumberTextField.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 30/03/2021.
//

import UIKit
import PhoneNumberKit

open class PhoneTextFieldView: UIView {
  let textField = PhoneTextField()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    initialize()
  }
  
  private func initialize() {
    borderColor = Asset.Colors.Primary.primaryDefault.color
    borderWidth = Dimensions.Fields.TextFields.borderWidth
    cornerRadius = Dimensions.Fields.TextFields.cornerRadius
    backgroundColor = .red
    
    addSubview(textField)
    textField.numberPlaceholderColor = .red
    textField.countryCodePlaceholderColor = .red
    
    textField.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(Configurations.UI.Spacing.p1)
    }
  }
}

open class PhoneTextField: PhoneNumberTextField {
  
  public var isValid: Bool?
  public var didTapFlagButton: VoidCallback?
  public var onInput: Callback<String?>?
  
  public init() {
    super.init(frame: .zero)
    initialize()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  public required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
  
  open override func textRect(forBounds bounds: CGRect) -> CGRect {
    return paddingRect(for: bounds).insetBy(dx: 4, dy: 4)
  }
  
  open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return paddingRect(for: bounds).insetBy(dx: 4, dy: 4)
  }
  
  open override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return paddingRect(for: bounds).insetBy(dx: 4, dy: 4)
  }
  
  open override func updateFlag() {
    let flagBase = UnicodeScalar("🇦").value - UnicodeScalar("A").value

    let flag = self.currentRegion
        .uppercased()
        .unicodeScalars
        .compactMap { UnicodeScalar(flagBase + $0.value)?.description }
        .joined()

    self.flagButton.setTitle(flag, for: .normal)
    self.flagButton.titleLabel?.font = UIFont.systemFont(ofSize: 28)
    self.flagButton.setControlEvent(.touchUpInside) { [weak self] in
      self?.didTapFlagButton?()
    }
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    if self.withFlag { // update the width of the flagButton automatically, iOS <13 doesn't handle this for you
      self.flagButton.frame.origin.y = self.frame.size.height - self.flagButton.frame.height
    }
  }

  open override func textFieldDidBeginEditing(_ textField: UITextField) {
    super.textFieldDidBeginEditing(textField)
    moveCursorToEnd()
  }

  @available (iOS 10.0, tvOS 10.0, *)
  open override func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    updateTextFieldDidEndEditing(textField)
    if let delegate = delegate {
        if (delegate.responds(to: #selector(textFieldDidEndEditing(_:reason:)))) {
          delegate.textFieldDidEndEditing?(textField, reason: reason)
        } else {
          delegate.textFieldDidEndEditing?(textField)
        }
    }
  }
  
  private func updateTextFieldDidEndEditing(_ textField: UITextField) {
      if self.withExamplePlaceholder, self.withPrefix, let countryCode = phoneNumberKit.countryCode(for: currentRegion)?.description,
          let text = textField.text,
          (text == internationalPrefix(for: countryCode) || text == "+") {
          textField.text = ""
          sendActions(for: .editingChanged)
          self.updateFlag()
          self.updatePlaceholder()
      }
  }
  
  func internationalPrefix(for countryCode: String) -> String? {
    guard let countryCode = phoneNumberKit.countryCode(for: currentRegion)?.description else { return nil }
    return "+" + countryCode
  }
  
  open override func updatePlaceholder() {
    guard let countryCode = phoneNumberKit.countryCode(for: currentRegion)?.description else {
      return }
    let countryCodeWithPlus = "+" + countryCode
    let ph = NSMutableAttributedString(string: countryCodeWithPlus)
    self.attributedPlaceholder = ph
  }
  
  public override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    guard let textField = textField as? PhoneNumberTextField else { return false }
    
    // Don't allow removing the + sign
    if range.contains(0) && string == "" {
      textField.text =  "+"
      return false
    } else if string.count > 1 {
      // Handle when the user copy and paste phone number
      let phone = "+" + string.integersOnlyString
      textField.text = "+" + string.integersOnlyString
      guard validatePhone(textField: textField, phoneNumber: phone) else { return false }
      updateFlag()
      updatePlaceholder()
      DispatchQueue.main.async {
        let newPosition = textField.endOfDocument
        textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
      }
      return false
    }
    
    guard let text = textField.text, let textRange = Range(range, in: text) else { return false }
    let updatedText = text.replacingCharacters(in: textRange, with: string)
    
    if validatePhone(textField: textField, phoneNumber: updatedText) {
      return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    } else {
      return false
    }
  }

  func validatePhone(textField: PhoneNumberTextField, phoneNumber: String) -> Bool {
    var currentRegion: String {
      // if the cureentRegion is invalid it comes as "001"
      textField.currentRegion == "001" ? "US" : textField.currentRegion
    }
    textField.partialFormatter.defaultRegion = currentRegion
    
    let exampleNumber = textField.phoneNumberKit.getFormattedExampleNumber(
      forCountry: currentRegion,
      withFormat: textField.withPrefix ? PhoneNumberFormat.international : .national,
      withPrefix: textField.withPrefix
    ) ?? "12345678"
    
    let isExceedingLength = phoneNumber.integersOnlyString.count > exampleNumber.integersOnlyString.count
    return !isExceedingLength
  }
  
}

private extension String {
  var integersOnlyString: String {
    self.filter { Int(String($0)) != nil }
  }
}


// MARK: - Private

private extension PhoneTextField {
  func initialize() {
    removeAccessoryView(direction: .left)
    removeAccessoryView(direction: .right)
    backgroundColor = .clear
    textColor = .red
    numberPlaceholderColor = .red
    countryCodePlaceholderColor = .red
    setPlaceHolderTextColor(.red)
    textAlignment = UILocalization.shared.textAlignment
    textContentType = .telephoneNumber
    keyboardType = .numbersAndPunctuation
    autocorrectionType = .yes
    addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    accessoryView(direction: UITextField.Direction.left, view: flagButton)
    withDefaultPickerUI = true
    withPrefix = true
    withFlag = true
    withExamplePlaceholder = true
    updateFlag()
    
    snp.makeConstraints { $0.height.equalTo(Dimensions.Fields.TextFields.height) }
  }
  
  func moveCursorToEnd() {
    // The usage of async here is needed because we need to queue
    // the movement of the cursor to be the first thing to happen after the textField didBeginEditing happens
    // see: https://stackoverflow.com/a/47464666 comments
    DispatchQueue.main.async {
      let newPosition = self.endOfDocument
      self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
    }
  }
}

public extension PhoneTextField {
  struct Country {
    public var code: String
    public var flag: String
    public var name: String
    public var prefix: String
    
    public func matches(_ query: String) -> Bool {
      return name.contains(query) || code.contains(query) || prefix.contains(query) || flag.contains(query)
    }
    
    public init?(for countryCode: String, with phoneNumberKit: PhoneNumberKit) {
      let flagBase = UnicodeScalar("🇦").value - UnicodeScalar("A").value
      guard
        let name = (Locale.current as NSLocale).localizedString(forCountryCode: countryCode),
        let prefix = phoneNumberKit.countryCode(for: countryCode)?.description
        else {
          return nil
      }
      
      self.code = countryCode
      self.name = name
      self.prefix = "+" + prefix
      self.flag = ""
      countryCode.uppercased().unicodeScalars.forEach {
        if let scaler = UnicodeScalar(flagBase + $0.value) {
          flag.append(String(describing: scaler))
        }
      }
      if flag.count != 1 { // Failed to initialize a flag ... use an empty string
        return nil
      }
    }
  }
  
  @objc func textDidChange() {
    onInput?(text)
  }
}
