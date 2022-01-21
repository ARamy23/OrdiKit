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
//  ButtonWithAccessory.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 21/05/2021.
//

import UIKit

public protocol ButtonWithAccessoryUIDataModelProtocol {
  var title: String { get set }
  var buttonStyle: ButtonStyle { get set }
  var accessoryView: UIView { get set }
  var onTap: VoidCallback { get set }
}

public struct ButtonWithAccessoryUIDataModel: ButtonWithAccessoryUIDataModelProtocol {
  public var title: String
  public var buttonStyle: ButtonStyle
  public var accessoryView: UIView
  public var onTap: VoidCallback
}

public final class ButtonWithAccessory: UIView, Configurable {
  let label = Label(font: .body, color: Asset.Colors.Primary.primaryDefault.color).then {
    $0.textAlignment = .center
    $0.setContentResistancePriorityCustom(.both(.must))
    $0.setContentHuggingPriorityCustom(.both(.must))
  }
  
  let overlayButton = Button(type: .system)
  
  lazy var hStack = UIStackView(
    arrangedSubviews: [
      label
    ], axis: .horizontal,
    spacing: 8,
    alignment: .center,
    distribution: .fillProportionally
  )
  
  public func configure(with viewModel: ButtonWithAccessoryUIDataModelProtocol) {
    label.text(viewModel.title)
    label.customTextColor = viewModel.buttonStyle.textColor
    hStack.addArrangedSubview(viewModel.accessoryView)
    overlayButton.type = .text(.empty, style: .overlay)
    overlayButton.setControlEvent(.touchUpInside) {
      viewModel.onTap()
    }
    backgroundColor = viewModel.buttonStyle.backgroundColor
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

private extension ButtonWithAccessory {
  func initialize() {
    self.cornerRadius = Dimensions.Buttons.cornerRadius
    
    addSubview(hStack)
    addSubview(overlayButton)
    
    hStack.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.leading.trailing.equalToSuperview().priority(999)
    }
    overlayButton.fillSuperview()
  }
}
