// Copyright (c) 2017-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

extension UIView {
    internal func fillSuperview() {
        fillSuperviewVertically()
        fillSuperviewHorizontally()
    }

    internal func fillSuperviewVertically() {
        guard let superview = superview else { return }

        self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }

    internal func fillSuperviewHorizontally() {
        guard let superview = superview else { return }

        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
    }
}
