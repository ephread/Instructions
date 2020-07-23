// Copyright (c) 2020-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

class CoachMarkBodyBackgroundView: UIView,
                                   CoachMarkBodyBackgroundStyle,
                                   CoachMarkComponent {
    // MARK: Private Constants
    private let minimumWidth: CGFloat = 17
    private let minimumHeight: CGFloat = 18

    private let foregroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()

    // MARK: Public Properties
    public var isHighlighted: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }

    public var cornerRadius: CGFloat = 8

    public lazy var innerColor = InstructionsColor.coachMarkInner
    public lazy var borderColor = InstructionsColor.coachMarkOuter

    public lazy var highlightedInnerColor = InstructionsColor.coachMarkHighlightedInner
    public lazy var highlightedBorderColor = InstructionsColor.coachMarkOuter

    // MARK: - Initialization
    override public init(frame: CGRect) {
        super.init(frame: frame)

        isUserInteractionEnabled = false

        layer.addSublayer(backgroundLayer)
        layer.addSublayer(foregroundLayer)

        initializeConstraints()
    }

    convenience public init() {
        self.init(frame: CGRect.zero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError(ErrorMessage.Fatal.doesNotSupportNSCoding)
    }

    // MARK: - Layout
    public override func layoutSubviews() {
        super.layoutSubviews()

        foregroundLayer.frame = bounds
        backgroundLayer.frame = bounds

        if isHighlighted {
            foregroundLayer.fillColor = highlightedInnerColor.cgColor
            backgroundLayer.fillColor = highlightedBorderColor.cgColor
        } else {
            foregroundLayer.fillColor = innerColor.cgColor
            backgroundLayer.fillColor = borderColor.cgColor
        }

        foregroundLayer.path = makeInnerRoundedPath(cornerRadius: cornerRadius - 0.5)
        backgroundLayer.path = makeOuterRoundedPath(cornerRadius: cornerRadius)
    }

    // MARK: Internal Methods
    func updateValues(from bodyBackground: CoachMarkBodyBackgroundStyle) {
        borderColor = bodyBackground.borderColor
        innerColor = bodyBackground.innerColor
        highlightedBorderColor = bodyBackground.highlightedBorderColor
        highlightedInnerColor = bodyBackground.highlightedInnerColor

        isHighlighted = bodyBackground.isHighlighted
        cornerRadius = bodyBackground.cornerRadius
    }

    // MARK: - Private Methods
    private func initializeConstraints() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(greaterThanOrEqualToConstant: minimumWidth),
            heightAnchor.constraint(greaterThanOrEqualToConstant: minimumHeight)
        ])
    }
}
