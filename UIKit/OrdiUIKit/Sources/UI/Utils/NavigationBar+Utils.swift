//
//  NavigationBar+Utils.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 10/3/20.
//  Copyright © 2020 Ahmed Ramy. All rights reserved.
//

import UIKit.UIViewController

public enum NavigationLayoutType {
  case leading
  case trailing
  case center
}

public protocol NavigationBarViewModelProtocol {
  var layout: NavigationLayoutType { get }
  var title: String { get }
  var buttonOnTap: VoidCallback? { get }
}

public protocol NavigationBarIconViewModelProtocol {
  var layout: NavigationLayoutType { get }
  var icon: UIImage { get }
  var buttonOnTap: VoidCallback? { get }
}

public struct NavigationBarViewModel: NavigationBarViewModelProtocol {
  public let layout: NavigationLayoutType
  public let title: String
  public let buttonOnTap: VoidCallback?

  public init(
    layout: NavigationLayoutType,
    title: String,
    buttonOnTap: @escaping VoidCallback = { }
  ) {
    self.layout = layout
    self.title = title
    self.buttonOnTap = buttonOnTap
  }
}

public struct NavigationBarIconViewModel: NavigationBarIconViewModelProtocol {
  public let layout: NavigationLayoutType
  public let icon: UIImage
  public let buttonOnTap: VoidCallback?

  public init(
    layout: NavigationLayoutType,
    icon: UIImage,
    buttonOnTap: @escaping VoidCallback = { }
  ) {
    self.layout = layout
    self.icon = icon
    self.buttonOnTap = buttonOnTap
  }
}

public protocol NavigationBarButtonViewModelProtocol {
  var icon: UIImage? { get }
  var title: String? { get }
  var buttonOnTap: VoidCallback { get }
}

public struct NavigationBarButtonViewModel: NavigationBarButtonViewModelProtocol {
  public let icon: UIImage?
  public let title: String?
  public let buttonOnTap: VoidCallback

  public init(
    icon: UIImage,
    buttonOnTap: @escaping VoidCallback = { }
  ) {
    self.icon = icon
    self.title = nil
    self.buttonOnTap = buttonOnTap
  }
  
  public init(
    title: String,
    buttonOnTap: @escaping VoidCallback = { }
  ) {
    self.title = title
    self.icon = nil
    self.buttonOnTap = buttonOnTap
  }
}

public protocol NavigationComponentProtocol {
  func addNavigationItem(with components: [NavigationComponentType])
}

public enum NavigationComponentType {
  case text(NavigationBarViewModelProtocol)
  case icon(NavigationBarIconViewModelProtocol)
  case search(text: String, placeholder: String, onSearching: Callback<String>)
  case buttons([NavigationBarButtonViewModelProtocol])
}

public extension NavigationComponentProtocol where Self: BaseViewController {
  func addNavigationItem(with components: [NavigationComponentType]) {
    components.forEach {
      switch $0 {
      case .text(let layoutType):
        text(viewModel: layoutType)
      case .icon(let layoutType):
        icon(viewModel: layoutType)
      case let .search(text, placeholder, onSearching):
        search(text: text, placeholder: placeholder, onSearching)
      case let .buttons(viewModels):
        buttons(viewModels)
      }
    }
  }
}

// MARK: - Text
private extension NavigationComponentProtocol where Self: BaseViewController {
  func text(viewModel: NavigationBarViewModelProtocol) {
    switch viewModel.layout {
    case .leading:
      navigationItem.leftBarButtonItem = .init(title: viewModel.title, actionClosure: { viewModel.buttonOnTap?() })
      navigationItem.leftItemsSupplementBackButton = true
    case .trailing:
      navigationItem.rightBarButtonItem = .init(title: viewModel.title, actionClosure: { viewModel.buttonOnTap?() })
    case .center:
      navigationItem.titleView = textView(viewModel: viewModel)
    }
  }
  
  func textView(viewModel: NavigationBarViewModelProtocol) -> NavigationLabelView {
    let view = NavigationLabelView()
    view.configure(with: viewModel)
    return view
  }
}

// MARK: - Icon
private extension NavigationComponentProtocol where Self: BaseViewController {
  func icon(viewModel: NavigationBarIconViewModelProtocol) {
    switch viewModel.layout {
    case .leading:
      navigationItem.leftBarButtonItem = .init(image: viewModel.icon, actionClosure: { viewModel.buttonOnTap?() })
      navigationItem.leftItemsSupplementBackButton = true
    case .trailing:
      navigationItem.rightBarButtonItem = .init(image: viewModel.icon, actionClosure: { viewModel.buttonOnTap?() })
    case .center:
      assertionFailure("Putting Icons in center is not supported.")
    }
  }
}

// MARK: - Search
private extension NavigationComponentProtocol where Self: BaseViewController {
  func search(text: String, placeholder: String, _ onSearching: @escaping Callback<String>) {
    let searchBar = UISearchBar()
    searchBar.placeholder = placeholder
    searchBar.sizeToFit()
    searchBar.text = text
    searchBar
      .textField?
      .onTextChange()
      .sink(receiveValue: { text in
        onSearching(text)
      }).store(in: &cancellables)
    navigationItem.titleView = searchBar
  }
}

// MARK: - Buttons
private extension NavigationComponentProtocol where Self: BaseViewController {
  func buttons(_ viewModels: [NavigationBarButtonViewModelProtocol]) {
    navigationItem.rightBarButtonItems = viewModels.map { vm -> UIBarButtonItem? in
      if let title = vm.title {
        return UIBarButtonItem(title: title, actionClosure: vm.buttonOnTap)
      } else if let image = vm.icon {
        return UIBarButtonItem(image: image, actionClosure: vm.buttonOnTap)
      } else {
        return nil
      }
    }.compactMap { $0 }
  }
}
