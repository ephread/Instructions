//
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

/// This class deals with the layout of the "skip" view
internal class SkipViewDisplayManager {
    //MARK: - Public properties
    /// Constraints defining the position of the "Skip" view
    private var skipViewConstraints: [NSLayoutConstraint] = []

    weak var dataSource: CoachMarksControllerProxyDataSource!

    //MARK: - Internal methods
    /// Will hide the current Skip View with a fading effect.
    ///
    /// - Parameter duration: the duration of the fade.
    func hideSkipView(skipView: CoachMarkSkipView, duration: NSTimeInterval = 0) {
        if duration == 0 {
            skipView.asView?.alpha = 0.0
        } else {
            UIView.animateWithDuration(duration) { () -> Void in
                skipView.asView?.alpha = 0.0
            }
        }
    }

    func showSkipView(skipView: CoachMarkSkipView, duration: NSTimeInterval = 0) {
        let constraints =
            self.dataSource.constraintsForSkipView(skipView.asView!,
                                                   inParentView: skipView.asView!.superview!)

        updateSkipView(skipView, withConstraints: constraints)

        skipView.asView?.superview?.bringSubviewToFront(skipView.asView!)

        if duration == 0 {
            skipView.asView?.alpha = 1.0
        } else {
            UIView.animateWithDuration(duration) { () -> Void in
                skipView.asView?.alpha = 1.0
            }
        }
    }

    /// Update the constraints defining the "Skip view" position.
    ///
    /// - Parameter layoutConstraints: the constraints to add.
    internal func updateSkipView(
        skipView: CoachMarkSkipView,
        withConstraints constraints: [NSLayoutConstraint]?
    ) {
        guard let parentView = skipView.asView?.superview else {
            print("skipView has no parent.")
            return
        }

        skipView.asView?.translatesAutoresizingMaskIntoConstraints = false
        parentView.removeConstraints(self.skipViewConstraints)

        self.skipViewConstraints = []

        if let constraints = constraints {
            self.skipViewConstraints = constraints
            parentView.addConstraints(self.skipViewConstraints)
        } else {
            self.skipViewConstraints.append(NSLayoutConstraint(
                item: skipView,
                attribute: .Trailing,
                relatedBy: .Equal,
                toItem: parentView,
                attribute: .Trailing,
                multiplier: 1,
                constant: -10
            ))

            var topConstant: CGFloat = 0.0

            #if !INSTRUCTIONS_APP_EXTENSIONS
            if !UIApplication.sharedApplication().statusBarHidden {
                topConstant = UIApplication.sharedApplication().statusBarFrame.size.height
            }
            #endif

            topConstant += 2

            self.skipViewConstraints.append(NSLayoutConstraint(
                item: skipView,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: parentView,
                attribute: .Top,
                multiplier: 1,
                constant: topConstant
            ))

            parentView.addConstraints(self.skipViewConstraints)
        }
    }
}
