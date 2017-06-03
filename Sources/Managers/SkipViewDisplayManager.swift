// SkipViewDisplayManager.swift
//
// Copyright (c) 2015, 2016 Frédéric Maquin <fred@ephread.com>
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

/// This class deals with the layout of the "skip" view.
class SkipViewDisplayManager {
    // MARK: - Internal properties
    /// Datasource providing the constraints to use.
    weak var dataSource: CoachMarksControllerProxyDataSource?

    // MARK: - Private properties
    /// Constraints defining the position of the "Skip" view
    private var skipViewConstraints: [NSLayoutConstraint] = []

    // MARK: - Internal methods
    /// Hide the given Skip View with a fading effect.
    ///
    /// - Parameter skipView: the skip view to hide.
    /// - Parameter duration: the duration of the fade.
    func hide(skipView: CoachMarkSkipView, duration: TimeInterval = 0) {
        if duration == 0 {
            skipView.asView?.alpha = 0.0
        } else {
            UIView.animate(withDuration: duration) { () -> Void in
                skipView.asView?.alpha = 0.0
            }
        }
    }

    /// Show the given Skip View with a fading effect.
    ///
    /// - Parameter skipView: the skip view to show.
    /// - Parameter duration: the duration of the fade.
    func show(skipView: CoachMarkSkipView, duration: TimeInterval = 0) {
        guard let parentView = skipView.asView?.superview else {
            print("The Skip View has no parent, aborting.")
            return
        }

        let constraints = self.dataSource?.constraintsForSkipView(skipView.asView!,
                                                                  inParent: parentView)

        update(skipView: skipView, withConstraints: constraints)

        skipView.asView?.superview?.bringSubview(toFront: skipView.asView!)

        if duration == 0 {
            skipView.asView?.alpha = 1.0
        } else {
            UIView.animate(withDuration: duration) { () -> Void in
                skipView.asView?.alpha = 1.0
            }
        }
    }

    /// Update the constraints defining the location of given s view.
    ///
    /// - Parameter skipView: the skip view to position.
    /// - Parameter constraints: the constraints to use.
    func update(skipView: CoachMarkSkipView,
                withConstraints constraints: [NSLayoutConstraint]?) {
        guard let parentView = skipView.asView?.superview else {
            print("The Skip View has no parent, aborting.")
            return
        }

        skipView.asView?.translatesAutoresizingMaskIntoConstraints = false
        parentView.removeConstraints(self.skipViewConstraints)

        self.skipViewConstraints = []

        if let constraints = constraints {
            self.skipViewConstraints = constraints
        } else {
            self.skipViewConstraints = defaultConstraints(for: skipView, in: parentView)
        }

        parentView.addConstraints(self.skipViewConstraints)
    }

    private func defaultConstraints(for skipView: CoachMarkSkipView, in parentView: UIView)
    -> [NSLayoutConstraint] {
        guard let skipView = skipView as? UIView else {
            print("Skip View is not an UIVIew, aborting.")
            return []
        }

        var constraints = [NSLayoutConstraint]()

        constraints.append(skipView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor,
                                                              constant: -10))

        var topConstant: CGFloat = 0.0

        #if !INSTRUCTIONS_APP_EXTENSIONS
            if !UIApplication.shared.isStatusBarHidden {
                topConstant = UIApplication.shared.statusBarFrame.size.height
            }
        #endif

        topConstant += 2

        constraints.append(skipView.topAnchor.constraint(equalTo: parentView.topAnchor,
                                                         constant: topConstant))

        return constraints
    }
}
