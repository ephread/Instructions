// Copyright (c) 2017-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

internal extension UIView {

    var isOutsideOfSuperviewsBounds: Bool {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return isOutsideOfSuperviewsBounds(consideringInsets: insets)
    }

    func isOutsideOfSuperviewsBounds(consideringInsets insets: UIEdgeInsets) -> Bool {
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

    func preparedForAutoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    func fillSuperview() {
        fillSuperviewVertically()
        fillSuperviewHorizontally()
    }

    func fillSuperview(insets: UIEdgeInsets) {
        guard let superview = superview else {
            print(ErrorMessage.Warning.noParent)
            return
        }

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right)
        ])
    }

    func fillSuperviewVertically() {
        guard let superview = superview else {
            print(ErrorMessage.Warning.noParent)
            return
        }

        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }

    func fillSuperviewHorizontally() {
        guard let superview = superview else {
            print(ErrorMessage.Warning.noParent)
            return
        }

        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
    }
}
