// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

// MARK: - Default Class
/// A concrete implementation of the coach mark arrow view and the
/// default one provided by the library.
public class DefaultCoachMarkPointerView: UIView,
                                          CoachMarkPointer,
                                          CoachMarkComponent {
    // MARK: Private Properties
    private let foregroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()

    private let position: ComputedVerticalPosition

    // MARK: Public Properties
    public var isHighlighted: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }

    public var background = CoachMarkArrowBackground()

    // MARK: - Initialization
    public init(position: ComputedVerticalPosition) {
        self.position = position

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

        foregroundLayer.path = makeInnerTrianglePath(position: position)
        backgroundLayer.path = makeOuterTrianglePath(position: position)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError(ErrorMessage.Fatal.doesNotSupportNSCoding)
    }

    // MARK: - Private
    private struct Constants {
        static let defaultWidth: CGFloat = 15
        static let defaultHeight: CGFloat = 9
    }
}

// MARK: - Private Methods
private extension DefaultCoachMarkPointerView {
    func initializeConstraints() {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: Constants.defaultWidth),
            heightAnchor.constraint(equalToConstant: Constants.defaultHeight)
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
