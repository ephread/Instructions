// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// A concrete implementation of the coach mark skip view and the
/// default one provided by the library.
public class CoachMarkSkipDefaultView: UIButton, CoachMarkSkipView {
    // MARK: Public properties
    public var skipControl: UIControl? {
        return self
    }

    public override var isHighlighted: Bool {
        didSet {
            bodyBackground.isHighlighted = isHighlighted
        }
    }

    public var background: CoachMarkBodyBackgroundStyle { return bodyBackground }
    public var isStyledByInstructions = true {
        didSet {
            bodyBackground.isHidden = !isStyledByInstructions
        }
    }

    // MARK: Private properties
    private var bodyBackground = CoachMarkBodyBackgroundView()

    // MARK: Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        accessibilityIdentifier = AccessibilityIdentifiers.skipButton
    }

    public convenience init() {
        self.init(frame: CGRect.zero)

        setTitleColor(InstructionsColor.coachMarkLabel, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        titleLabel?.textAlignment = .center

        bodyBackground.translatesAutoresizingMaskIntoConstraints = false
        bodyBackground.isUserInteractionEnabled = false

        addSubview(bodyBackground)
        sendSubviewToBack(bodyBackground)
        bodyBackground.fillSuperview()

        contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
        sizeToFit()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError(ErrorMessage.Fatal.doesNotSupportNSCoding)
    }
}
