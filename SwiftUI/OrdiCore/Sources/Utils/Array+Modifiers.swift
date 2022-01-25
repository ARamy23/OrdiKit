//
//  File.swift
//  
//
//  Created by Ahmed Ramy on 25/01/2022.
//

import Foundation

public extension Array where Element: Identifiable {
  mutating func findAndReplaceElseAppend(with replacer: Element) {
    if let index = firstIndex(where: { $0.id == replacer.id }) {
      self[index] = replacer
    } else {
      self.append(replacer)
    }
  }
  
  mutating func findAndReplace(with replacer: Element) {
    guard let index = firstIndex(where: { $0.id == replacer.id }) else { return }
    self[index] = replacer
  }
  
  mutating func findAndRemove(_ target: Element) {
    removeAll(where: { $0.id == target.id })
  }
}