// CoachMarksViewController+Regular.swift
//
// Copyright (c) 2018 Frédéric Maquin <fred@ephread.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

// MARK: - Extension: Controller Containment
extension CoachMarksViewController {
    /// Will attach the controller as the rootViewController of a given window. This will
    /// allow the coach mark controller to respond to size changes and present itself
    /// above evrything.
    ///
    /// - Parameter window: the window holding the controller
    func attach(to window: UIWindow, of viewController: UIViewController) {
        window.windowLevel = overlayManager.windowLevel

        retrieveConfig(from: viewController)

        registerForSystemEventChanges()
        addOverlayView()

        window.rootViewController = self
        window.isHidden = false
    }

    /// Detach the controller from its parent view controller.
    func detachFromWindow() {
        deregisterFromSystemEventChanges()
        self.view.window?.isHidden = true
        self.view.window?.rootViewController = nil
    }
}
