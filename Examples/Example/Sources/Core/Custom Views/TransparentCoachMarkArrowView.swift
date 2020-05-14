// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

// Transparent coach mark (text without background, cool arrow)
internal class TransparentCoachMarkArrowView: UIImageView, CoachMarkArrowView {
    // MARK: - Initialization
    init(orientation: CoachMarkArrowOrientation) {
        if orientation == .top {
            super.init(image: UIImage(named: "arrow-top"))
        } else {
            super.init(image: UIImage(named: "arrow-bottom"))
        }

        self.translatesAutoresizingMaskIntoConstraints = false

        widthAnchor.constraint(equalToConstant: self.image?.size.width ?? 0).isActive = true
        heightAnchor.constraint(equalToConstant: self.image?.size.width ?? 0).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }
}
