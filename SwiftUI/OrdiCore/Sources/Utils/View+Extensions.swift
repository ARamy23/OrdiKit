//
//  View+Extensions.swift
//  
//
//  Created by Ahmed Ramy on 19/01/2022.
//

import SwiftUI

public extension View {
  func fill() -> some View {
    self.frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  func fillOnLeading() -> some View {
    self
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  func fillOnTrailing() -> some View {
    self
      .frame(maxWidth: .infinity, alignment: .trailing)
  }
  
  func fillAndCenter() -> some View {
    self
      .frame(maxWidth: .infinity, alignment: .center)
  }
  
  func getSafeArea() -> UIEdgeInsets {
    return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
      .windows.first?.safeAreaInsets ?? .zero
  }
}
