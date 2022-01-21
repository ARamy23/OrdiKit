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
//  LoadingButton.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 23/04/2021.
//

import UIKit

open class LoadingButton: Button {
  lazy var activityIndicator: UIActivityIndicatorView = {
    
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.hidesWhenStopped = true
    self.addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
    return activityIndicator
  }()
  
  var didConstraintWidth: Bool = false
  
  public func startLoading() {
    hideUI()
    placeActivityIndicator()
    layoutSubviews()
  }
  
  public func stopLoading() {
    showUI()
    removeActivityIndicator()
    layoutSubviews()
  }
  
  private func showUI() {
    updateType()
  }
  
  private func hideUI() {
    constraintWidthIfNeeded()
    setText("", buttonStyle: .disabled)
    setIcon(UIImage(), tintColor: nil, farEdge: false)
  }
  
  private func constraintWidthIfNeeded() {
    if !didConstraintWidth {
      snp.makeConstraints { (make) in
        make.width.equalTo(self.frame.size.width)
      }
      didConstraintWidth = true
    }
  }
  
  private func placeActivityIndicator() {
    activityIndicator.startAnimating()
  }
  
  private func removeActivityIndicator() {
    activityIndicator.stopAnimating()
  }
}
