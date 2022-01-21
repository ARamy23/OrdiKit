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
//  InformationUIBuilder.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 01/05/2021.
//

import UIKit

public protocol InformationUIDataModelProtocol {
  var fields: [InformationDataType] { get }
}

public protocol InformationFieldDataModelProtocol {
  var name: String { get }
  var value: String { get }
}

public enum InformationDataType {
  case image(VisualContent)
  case field(InformationFieldDataModelProtocol)
}

public struct InformationFieldDataModel: InformationFieldDataModelProtocol {
  public var name: String
  public var value: String
}

public struct InformationUIDataModel: InformationUIDataModelProtocol {
  public let fields: [InformationDataType]
}

public final class InformationUIBuilder: UIBuilder {
  
  let uiModel: InformationUIDataModelProtocol
  
  init(uiModel: InformationUIDataModelProtocol) {
    self.uiModel = uiModel
  }
  
  public func build() -> UIView {
    let vStack = UIStackView(
      arrangedSubviews: uiModel.fields.map {
        self.createViewFrom($0)
      },
      axis: .vertical,
      spacing: Configurations.UI.Spacing.p1,
      alignment: .fill,
      distribution: .fill
    )
    
    vStack.setLayoutMargin(.horizontal(Configurations.UI.Spacing.p2))
    
    return vStack
  }
  
  private func createViewFrom(_ type: InformationDataType) -> UIView {
    switch type {
    case let .image(visualContent):
      let imageView = UIImageView().then {
        $0.set(visual: visualContent)
        $0.cornerRadius = 8
        $0.contentMode = .scaleAspectFill
      }
      
      let view = UIView()
      view.addSubview(imageView)
      
      imageView.snp.makeConstraints {
//        $0.size.equalTo(Configurations.UI.Profile.pictureSize)
        $0.centerX.equalToSuperview()
        $0.top.bottom.equalToSuperview()
      }
      
      return view
    case let .field(fieldData):
      return UIStackView(
        arrangedSubviews: [
          Label(font: .subheadline, color: Asset.Colors.Primary.primaryDefault.color).then {
            $0.text(fieldData.name)
            $0.setContentHuggingPriorityCustom(.both(.must))
          },
          Label(font: .body, color: Asset.Colors.Primary.primaryDefault.color).then {
            $0.text(fieldData.value)
            $0.edgeInsets = .init(horizontal: Configurations.UI.Spacing.p1, vertical: Configurations.UI.Spacing.p05)
            $0.backgroundColor = Asset.Colors.Secondary.secondaryDefault.color
            $0.cornerRadius = 8
            $0.setContentHuggingPriorityCustom(.both(.must))
          },
        ],
        axis: .vertical,
        spacing: Configurations.UI.Spacing.p05,
        alignment: .fill,
        distribution: .fill
      )
    }
  }
}
