// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

// Custom coach mark body (with the secret-like arrow)
internal class CustomCoachMarkBodyView: UIView, CoachMarkBodyView {
    // MARK: - Internal properties
    var nextControl: UIControl? { return self.nextButton }

    var highlighted: Bool = false

    var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.accessibilityIdentifier = AccessibilityIdentifiers.next

        return nextButton
    }()

    var hintLabel = UITextView()

    weak var highlightArrowDelegate: CoachMarkBodyHighlightArrowDelegate?

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
        self.backgroundColor = UIColor.white

        self.clipsToBounds = true
        self.layer.cornerRadius = 4

        self.hintLabel.backgroundColor = UIColor.clear
        self.hintLabel.textColor = UIColor.darkGray
        self.hintLabel.font = UIFont.systemFont(ofSize: 15.0)
        self.hintLabel.isScrollEnabled = false
        self.hintLabel.textAlignment = .left
        self.hintLabel.isEditable = false

        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.hintLabel.translatesAutoresizingMaskIntoConstraints = false

        self.nextButton.isUserInteractionEnabled = true
        self.hintLabel.isUserInteractionEnabled = false

        self.nextButton.setBackgroundImage(UIImage(named: "button-background"),
                                           for: .normal)
        self.nextButton.setBackgroundImage(UIImage(named: "button-background-highlighted"),
                                           for: .highlighted)

        self.nextButton.setTitleColor(UIColor.white, for: .normal)
        self.nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)

        self.addSubview(nextButton)
        self.addSubview(hintLabel)

        NSLayoutConstraint.activate([
            nextButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 30),

            hintLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            hintLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])

        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-(10)-[hintLabel]-(10)-[nextButton(==40)]-(10)-|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: nil,
                views: ["hintLabel": hintLabel, "nextButton": nextButton]
            )
        )
    }
}
