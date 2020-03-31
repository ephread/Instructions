// Copyright (c) 2017-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

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
