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
//  BaseViewController.swift
//  ARamy
//
//  Created by Ahmed Ramy on 30/11/2021.
//

import UIKit
import Combine
import PulseUI
import SnapKit

public protocol HasViewModel {
    associatedtype ViewModelType: ViewModelable
    var viewModel: ViewModelType? { get set }
}

public class BaseViewController: UIViewController {
    public var cancellables: Set<AnyCancellable> = []

    var viewWillAppearCalledBefore: Bool = false
    var viewDidAppearCalledBefore: Bool = false

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !viewWillAppearCalledBefore {
            viewWillAppearCalledBefore = true
            viewWillAppearOnce()
        }
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !viewDidAppearCalledBefore {
            viewDidAppearCalledBefore = true
            viewDidAppearOnce()
        }
    }

    open func viewWillAppearOnce() {
      let baseView = FoundationUIBuilder().build()
      self.view.addSubview(baseView)
      baseView.fillSuperview()
    }

    open func viewDidAppearOnce() {
        /* Override in Children when needed */
    }

    open func showLoadingState(isLoading _: Bool) {
        /* Override in Children when needed */
    }
}

extension HasViewModel where Self: BaseViewController {
    func bindState() {
        viewModel?.error.sink(receiveValue: { [weak self] error in
            guard let error = error else { return }
            self?.showError(error: error)
        }).store(in: &cancellables)
        
        viewModel?.successMessage.sink(receiveValue: { [weak self] success in
            guard !success.isEmpty else { return }
          self?.showSucessMessage(successMessage: success)
        }).store(in: &cancellables)
        
        viewModel?.isLoading.sink(receiveValue: { [weak self] isLoading in
            self?.showLoadingState(isLoading: isLoading)
        }).store(in: &cancellables)
    }
}

public extension BaseViewController {
    override func becomeFirstResponder() -> Bool {
        true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with _: UIEvent?) {
        if motion == .motionShake {
            print("Shake Gesture Detected")
            present(MainViewController(), shouldBeFullScreen: false)
        }
    }
}
