// Copyright (c)  2020-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

class CoachMarkBodyBackgroundView: UIView,
                                   CoachMarkBodyBackground,
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

    public lazy var innerColor: UIColor = makeInnerColor()
    public lazy var borderColor: UIColor = makeBorderColor()

    public lazy var highlightedInnerColor: UIColor = makeHighlightedInnerColor()
    public lazy var highlightedBorderColor: UIColor = makeBorderColor()

    // MARK: - Initialization
    override public init(frame: CGRect) {
        super.init(frame: frame)

        layer.addSublayer(backgroundLayer)
        layer.addSublayer(foregroundLayer)

        initializeConstraints()
    }

    convenience public init() {
        self.init(frame: CGRect.zero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }

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

    func initializeConstraints() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(greaterThanOrEqualToConstant: minimumWidth),
            heightAnchor.constraint(greaterThanOrEqualToConstant: minimumHeight)
        ])
    }
}
