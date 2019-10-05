// UIView+Layout.swift
//
// Copyright (c) 2017 Frédéric Maquin <fred@ephread.com>
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

internal extension UIView {

    var isOutOfSuperview: Bool {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return isOutOfSuperview(consideringInsets: insets)
    }

    func isOutOfSuperview(consideringInsets insets: UIEdgeInsets) -> Bool {
        guard let superview = self.superview else {
            return true
        }

        let isInBounds = frame.origin.x >= insets.left && frame.origin.y >= insets.top
                         &&
                         (frame.origin.x + frame.size.width) <=
                         (superview.frame.size.width - insets.right)
                         &&
                         (frame.origin.y + frame.size.height) <=
                         (superview.frame.size.height - insets.bottom)

        return !isInBounds
    }

    func fillSuperview() {
        fillSuperviewVertically()
        fillSuperviewHorizontally()
    }

    func fillSuperviewVertically() {
        for constraint in makeConstraintToFillSuperviewVertically() { constraint.isActive = true }
    }

    func fillSuperviewHorizontally() {
        for constraint in makeConstraintToFillSuperviewHorizontally() { constraint.isActive = true }
    }

    func makeConstraintToFillSuperviewVertically() -> [NSLayoutConstraint] {
        guard let superview = superview else {
            print("[WARNING] View has no parent, cannot define constraints.")
            return []
        }

        return [
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ]
    }

    func makeConstraintToFillSuperviewHorizontally() -> [NSLayoutConstraint] {
        guard let superview = superview else {
            print("[WARNING] View has no parent, cannot define constraints.")
            return []
        }

        return [
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ]
    }
}
