// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

// MARK: - Default Class
/// A concrete implementation of the coach mark arrow view and the
/// default one provided by the library.
public class CoachMarkArrowDefaultView: UIImageView, CoachMarkArrowView {
    // MARK: - Initialization
    public init(orientation: CoachMarkArrowOrientation) {
        let image, highlightedImage: UIImage?

        if orientation == .top {
            image = UIImage(namedInInstructions: "arrow-top")
            highlightedImage = UIImage(namedInInstructions: "arrow-top-highlighted")
        } else {
            image = UIImage(namedInInstructions: "arrow-bottom")
            highlightedImage = UIImage(namedInInstructions: "arrow-bottom-highlighted")
        }

        super.init(image: image, highlightedImage: highlightedImage)

        initializeConstraints()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }
}

// MARK: - Private Inner Setup
private extension CoachMarkArrowDefaultView {
    func initializeConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: self.image!.size.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: self.image!.size.height).isActive = true
    }
}
