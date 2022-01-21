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
//  TextView.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 21/05/2021.
//

import UIKit

public class TextView: UITextView {
  
  /// Resize the placeholder when the UITextView bounds change
  override open var bounds: CGRect {
    didSet {
      self.resizePlaceholder()
    }
  }
  
  /// The UITextView placeholder text
  public var placeholder: String? {
    get {
      var placeholderText: String?
      
      if let placeholderLabel = self.viewWithTag(100) as? UILabel {
        placeholderText = placeholderLabel.text
      }
      
      return placeholderText
    }
    set {
      if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
        placeholderLabel.text = newValue
        placeholderLabel.sizeToFit()
      } else {
        self.addPlaceholder(newValue!)
      }
    }
  }
  
  public var onInput: Callback<String>?
  
  /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
  ///
  /// - Parameter textView: The UITextView that got updated
  public func textViewDidChange(_ textView: UITextView) {
    if let placeholderLabel = self.viewWithTag(100) as? UILabel {
      placeholderLabel.isHidden = !self.text.isEmpty
    }
    onInput?(textView.text)
  }
  
  /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
  private func resizePlaceholder() {
    if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
      let labelX = self.textContainer.lineFragmentPadding
      let labelY = self.textContainerInset.top - 2
      let labelWidth = self.frame.width - (labelX * 2)
      let labelHeight = placeholderLabel.frame.height
      
      placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
    }
  }
  
  /// Adds a placeholder UILabel to this UITextView
  private func addPlaceholder(_ placeholderText: String) {
    let placeholderLabel = UILabel()
    
    placeholderLabel.text = placeholderText
    placeholderLabel.sizeToFit()
    
    placeholderLabel.font = self.font
    placeholderLabel.textColor = UIColor.lightGray
    placeholderLabel.tag = 100
    
    placeholderLabel.isHidden = !self.text.isEmpty
    
    self.addSubview(placeholderLabel)
    self.resizePlaceholder()
    self.delegate = self
  }
}

extension TextView: UITextViewDelegate {
  
}
