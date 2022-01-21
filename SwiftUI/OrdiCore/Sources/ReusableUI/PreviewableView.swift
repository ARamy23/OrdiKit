//
//  PreviewableView.swift
//  Trojan
//
//  Created by Ahmed Ramy on 17/01/2022.
//

import SwiftUI

public typealias PreviewableView<T: View> = WrapperView<T>

public struct WrapperView<Content: View>: View {
    private let injectedView: () -> Content
    
    public init(@ViewBuilder injectedView: @escaping () -> Content) {
        self.injectedView = injectedView
    }
    
    public var body: some View {
      Group {
        injectedView()
        injectedView()
          .preferredColorScheme(.dark)
        injectedView()
          .previewDevice("iPhone 8")
        injectedView()
          .previewDevice("iPod touch (7th generation)")
        injectedView()
          .previewDevice("iPad Pro (12.9-inch) (5th generation)")
      }
    }
}
