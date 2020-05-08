// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

// Transparent coach mark (text without background, cool arrow)
internal class TransparentCoachMarkBodyView: UIControl, CoachMarkBodyView {
    // MARK: - Internal properties
    var nextControl: UIControl? { return self }

    weak var highlightArrowDelegate: CoachMarkBodyHighlightArrowDelegate?

    var hintLabel = UITextView()

    // MARK: - Initialization
    override init (frame: CGRect) {
        super.init(frame: frame)

        self.setupInnerViewHierarchy()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }

    // MARK: - Private methods
    private func setupInnerViewHierarchy() {
        self.translatesAutoresizingMaskIntoConstraints = false

        hintLabel.backgroundColor = UIColor.clear
        hintLabel.textColor = UIColor.white
        hintLabel.font = UIFont.systemFont(ofSize: 15.0)
        hintLabel.isScrollEnabled = false
        hintLabel.textAlignment = .justified
        hintLabel.layoutManager.hyphenationFactor = 1.0
        hintLabel.isEditable = false

        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.isUserInteractionEnabled = false

        self.addSubview(hintLabel)
        hintLabel.fillSuperview()
    }
}
