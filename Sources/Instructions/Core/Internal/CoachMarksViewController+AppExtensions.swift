// CoachMarksViewController+AppExtensions.swift
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
    /// Will attach the controller as a child of the given view controller. This will
    /// allow the coach mark controller to respond to size changes.
    /// `instructionsRootView` will be a subview of `parentViewController.view`.
    ///
    /// - Parameter parentViewController: the controller of which become a child
    func attach(to parentViewController: UIViewController) {
        guard let window = parentViewController.view?.window else {
            print("attachToViewController: Instructions could not be properly" +
                "attached to the window, did you call `startOn` inside" +
                "`viewDidLoad` instead of `ViewDidAppear`?")

            return
        }

        retrieveConfig(from: parentViewController)

        parentViewController.addChildViewController(self)
        parentViewController.view.addSubview(self.view)

        registerForSystemEventChanges()
        addRootView(to: window)
        addOverlayView()

        self.didMove(toParentViewController: parentViewController)

        window.layoutIfNeeded()
    }

    /// Detach the controller from its parent view controller.
    func detachFromWindow() {
        self.instructionsRootView.removeFromSuperview()
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        deregisterFromSystemEventChanges()
    }
}
