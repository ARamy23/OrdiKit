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
//  PickerView.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 05/04/2021.
//

import UIKit

public protocol PickerUIDataModelProtocol {
  var rows: [PickerRowDataModelProtocol] { get set }
  var selectedRow: String { get set }
  var onSelect: Callback<PickerRowDataModelProtocol> { get set }
}

public protocol PickerRowDataModelProtocol {
  var id: String { get set }
  var title: String { get set }
}

public struct PickerUIDataModel: PickerUIDataModelProtocol {
  public var rows: [PickerRowDataModelProtocol]
  public var selectedRow: String
  public var onSelect: Callback<PickerRowDataModelProtocol>
}

public struct PickerRowDataModel: PickerRowDataModelProtocol {
  public var id: String
  public var title: String
}

public final class PickerView: UIPickerView, Configurable {
  var uiModel: PickerUIDataModelProtocol!
  
  public func configure(with viewModel: PickerUIDataModelProtocol) {
    self.uiModel = viewModel
    self.delegate = self
    self.dataSource = self
    self.reloadAllComponents()
    guard let selectedRowIndex = viewModel.rows.firstIndex(where: { $0.id == viewModel.selectedRow }) else { return }
    self.selectRow(selectedRowIndex, inComponent: 0, animated: false)
  }
}

extension PickerView: UIPickerViewDataSource, UIPickerViewDelegate {
  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }
  
  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    uiModel.rows.count
  }
  
  public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    uiModel.rows[row].title
  }
  
  public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    uiModel.onSelect(uiModel.rows[row])
  }
}
