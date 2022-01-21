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
//  RatingsFactory.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 31/05/2021.
//  Copyright © 2021 RamySDK. All rights reserved.
//

import SwiftEntryKit

public final class RatingsFactory {
  
  private static func getDefaultRatingAttributes() -> EKAttributes {
    var attribute = EKAttributes()
    attribute.border = .none
    attribute.hapticFeedbackType = .success
    attribute.entryBackground = .color(color: .init(ThemeManager.shared.selectedTheme.transparency.light(by: 95)))
    attribute.screenBackground = .color(color: .init(ThemeManager.shared.selectedTheme.transparency.dark(by: 65)))
    attribute.entryInteraction = .absorbTouches
    attribute.displayDuration = .infinity
    attribute.displayMode = .inferred
    attribute.hapticFeedbackType = .success
    attribute.roundCorners = .all(radius: Metrics.radius.getMetric(for: .ratingForm))
    attribute.entranceAnimation = .translation
    attribute.exitAnimation = .translation
    attribute.exitAnimation = .translation
    attribute.position = .center
    attribute.positionConstraints = .float
    
    return attribute
  }
  
  static func showRatingView(viewModel: RatingViewModel) {
    let unselectedImage = EKProperty.ImageContent(
      image: Asset.Icons.star.image,
      displayMode: .inferred,
      tint: EKColor.init(.mono.offblack)
    )
    let selectedImage = EKProperty.ImageContent(
      image: Asset.Icons.filledStar.image,
      displayMode: .inferred,
      tint: EKColor.init(.mono.offblack)
    )
    
    let steps = viewModel.steps.map { step -> (title: EKProperty.LabelContent, description: EKProperty.LabelContent, items: [EKProperty.EKRatingItemContent]) in
      let title = EKProperty.LabelContent(
        text: step.title,
        style: .init(
          font: FontManager.shared.getSuitableFont(
            category: .link,
            scale: .medium,
            weight: .bold
          ).font,
          color: EKColor.init(.mono.offblack),
          alignment: .center,
          displayMode: .inferred
        )
      )
      
      let description = EKProperty.LabelContent(
        text: step.description,
        style: .init(
          font: FontManager.shared.getSuitableFont(
            category: .link,
            scale: .xsmall,
            weight: .regular
          ).font,
          color: EKColor.init(.mono.body),
          alignment: .center,
          displayMode: .inferred
        )
      )
      
      let items = step.content.map { item -> EKProperty.EKRatingItemContent in
        let itemTitle = EKProperty.LabelContent(
          text: item.title,
          style: .init(
            font: FontManager.shared.getSuitableFont(category: .display, scale: .huge, weight: .bold).font,
            color: .init(.mono.offblack),
            alignment: .center,
            displayMode: .inferred
          )
        )
        
        let itemDescription = EKProperty.LabelContent(
          text: item.description,
          style: .init(
            font: FontManager.shared.getSuitableFont(
              category: .link,
              scale: .xsmall,
              weight: .regular
            ).font,
            color: EKColor.init(.mono.body),
            alignment: .center,
            displayMode: .inferred
          )
        )
        return EKProperty.EKRatingItemContent(
          title: itemTitle,
          description: itemDescription,
          unselectedImage: unselectedImage,
          selectedImage: selectedImage
        )
      }
      
      return (title: title, description: description, items: items)
    }
    
    var message: EKRatingMessage!
    let lightFont = FontManager.shared.getSuitableFont(
      category: .text,
      scale: .xsmall,
      weight: .regular
    ).font
    
    let mediumFont = FontManager.shared.getSuitableFont(
      category: .text,
      scale: .xsmall,
      weight: .bold
    ).font
    
    let closeButtonLabelStyle = EKProperty.LabelStyle(
      font: lightFont,
      color: .init(.primary.default),
      displayMode: .inferred
    )
    
    let closeButtonLabel = EKProperty.LabelContent(
      text: "Dismiss".localized(),
      style: closeButtonLabelStyle
    )
    
    let closeButton = EKProperty.ButtonContent(
      label: closeButtonLabel,
      backgroundColor: .clear,
      highlightedBackgroundColor: .init(.transparency.light(by: 65)),
      displayMode: .inferred) {
      SwiftEntryKit.dismiss {
        // Here you may perform a completion handler
      }
    }
    
    let okButtonLabelStyle = EKProperty.LabelStyle(
      font: mediumFont,
      color: .init(.primary.default),
      displayMode: .inferred
    )
    let okButtonLabel = EKProperty.LabelContent(
      text: "Tell us more".localized(),
      style: okButtonLabelStyle
    )
    
    let okButton = EKProperty.ButtonContent(
      label: okButtonLabel,
      backgroundColor: .clear,
      highlightedBackgroundColor: EKColor(.transparency.light(by: 65)),
      displayMode: .inferred) {
      SwiftEntryKit.dismiss()
    }
    
    let buttonsBarContent = EKProperty.ButtonBarContent(
      with: closeButton, okButton,
      separatorColor: .init(.mono.line),
      horizontalDistributionThreshold: 2,
      displayMode: .inferred,
      expandAnimatedly: true
    )
    
    message = EKRatingMessage(
      initialTitle: steps.first!.title,
      initialDescription: steps.first!.description,
      ratingItems: steps.first!.items,
      buttonBarContent: buttonsBarContent) { index in
      // Rating selected - do something
    }
    
    let contentView = EKRatingMessageView(with: message)
    SwiftEntryKit.display(entry: contentView, using: getDefaultRatingAttributes())
  }
}

public extension RatingsFactory {
  struct RatingViewModel {
    let steps: [RatingStep]
  }
}

public extension RatingsFactory.RatingViewModel {
  struct RatingStep {
    let title: String
    let description: String
    let content: [RatingContent]
  }
  
  struct RatingContent {
    let title: String
    let description: String
  }
}
