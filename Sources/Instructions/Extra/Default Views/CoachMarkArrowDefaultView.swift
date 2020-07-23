// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

// MARK: - Default Class
/// A concrete implementation of the coach mark arrow view and the
/// default one provided by the library.
public class CoachMarkArrowDefaultView: UIView,
                                        CoachMarkArrowView,
                                        CoachMarkComponent {

    // MARK: Private Constants
    private let defaultWidth: CGFloat = 15
    private let defaultHeight: CGFloat = 9

    private let foregroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()

    private let orientation: CoachMarkArrowOrientation

    // MARK: Public Properties
    public var isHighlighted: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }

    public var background = CoachMarkArrowBackground()

    // MARK: - Initialization
    public init(orientation: CoachMarkArrowOrientation) {
        self.orientation = orientation

        super.init(frame: .zero)

        layer.addSublayer(backgroundLayer)
        layer.addSublayer(foregroundLayer)

        initializeConstraints()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        foregroundLayer.frame = bounds
        backgroundLayer.frame = bounds

        if isHighlighted {
            foregroundLayer.fillColor = background.highlightedInnerColor.cgColor
            backgroundLayer.fillColor = background.highlightedBorderColor.cgColor
        } else {
            foregroundLayer.fillColor = background.innerColor.cgColor
            backgroundLayer.fillColor = background.borderColor.cgColor
        }

        foregroundLayer.path = makeInnerTrianglePath(orientation: orientation)
        backgroundLayer.path = makeOuterTrianglePath(orientation: orientation)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError(ErrorMessage.Fatal.doesNotSupportNSCoding)
    }
}

// MARK: - Private Methods
private extension CoachMarkArrowDefaultView {
    func initializeConstraints() {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: defaultWidth),
            heightAnchor.constraint(equalToConstant: defaultHeight)
        ])
    }
}

// MARK: - Background Style
public struct CoachMarkArrowBackground: CoachMarkBackgroundStyle {
    public var innerColor = InstructionsColor.coachMarkInner
    public var borderColor = InstructionsColor.coachMarkOuter

    public var highlightedInnerColor = InstructionsColor.coachMarkHighlightedInner
    public var highlightedBorderColor = InstructionsColor.coachMarkOuter
}
