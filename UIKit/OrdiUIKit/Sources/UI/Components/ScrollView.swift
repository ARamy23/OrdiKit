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
//  ScrollView.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 10/13/20.
//  Copyright © 2020 Ahmed Ramy. All rights reserved.
//

import UIKit

public final class ScrollView: UIScrollView, UIScrollViewDelegate {
  
  var shouldDisableTopBounce: Bool = false
  
  var scrollableContentView: UIView! {
    didSet {
      self.removeSubviews()
      self.addSubview(scrollableContentView)
      
      scrollableContentView.snp.makeConstraints { (make) in
        make.top.leading.trailing.centerX.equalToSuperview()
        make.centerY.equalToSuperview().priority(250)
        make.bottom.equalToSuperview().inset(Configurations.UI.Spacing.scrollViewBottomPadding).priority(250)
        make.width.equalToSuperview()
      }
    }
  }
  
  public override var contentLayoutGuide: UILayoutGuide {
    .init()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    initialize()
  }
}

extension ScrollView {
  func initialize() {
    self.clipsToBounds = false
    self.delegate = self
  }
}

public extension ScrollView {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard shouldDisableTopBounce else { return }
    if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
        scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
    }
  }
}
