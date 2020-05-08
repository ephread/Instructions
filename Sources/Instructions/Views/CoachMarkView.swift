// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

// swiftlint:disable force_cast

/// The actual coach mark that will be displayed.
class CoachMarkView: UIView {
    // MARK: - Internal properties

    /// The body of the coach mark (likely to contain some text).
    let bodyView: CoachMarkBodyView

    /// The arrow view, note that the arrow view is not mandatory.
    private(set) var arrowView: CoachMarkArrowView?

    /// The arrow orientation (where it will sit relative to the body view, i.e.
    /// above or below.)
    private(set) var arrowOrientation: CoachMarkArrowOrientation?

    /// The offset (in case the arrow is required to overlap the body)
    var arrowOffset: CGFloat = 0.0

    /// The control used to get to the next coach mark.
    var nextControl: UIControl? {
        return bodyView.nextControl
    }

    // MARK: - Private properties
    private var bodyUIView: UIView { return bodyView as! UIView }
    private var arrowUIView: UIView? { return arrowView as? UIView }
    private var innerConstraints = CoachMarkViewConstraints()
    private let coachMarkLayoutHelper: CoachMarkInnerLayoutHelper

    // MARK: - Initialization

    /// Allocate and initliaze the coach mark view, with the given subviews.
    ///
    /// - Parameter bodyView:         the mandatory body view
    /// - Parameter arrowView:        the optional arrow view
    /// - Parameter arrowOrientation: the arrow orientation, either .Top or .Bottom
    /// - Parameter arrowOffset:      the arrow offset (in case the arrow is required
    ///                               to overlap the body) - a positive number
    ///                               will make the arrow overlap.
    /// - Parameter coachMarkInnerLayoutHelper: auto-layout constraints helper.
    init(bodyView: UIView & CoachMarkBodyView,
         arrowView: (UIView & CoachMarkArrowView)? = nil,
         arrowOrientation: CoachMarkArrowOrientation? = nil, arrowOffset: CGFloat? = nil,
         coachMarkInnerLayoutHelper: CoachMarkInnerLayoutHelper) {

        self.bodyView = bodyView
        self.arrowView = arrowView
        self.arrowOrientation = arrowOrientation
        self.coachMarkLayoutHelper = coachMarkInnerLayoutHelper

        if let arrowOffset = arrowOffset {
            self.arrowOffset = arrowOffset
        }

        super.init(frame: CGRect.zero)

        self.bodyView.highlightArrowDelegate = self
        self.layoutViewComposition()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }

    // MARK: - Internal Method

    //TODO: Better documentation
    /// Change the arrow horizontal position to the given position.
    /// `position` is relative to:
    /// - `.Leading`: `offset` is relative to the leading edge of the overlay;
    /// - `.Center`: `offset` is relative to the center of the overlay;
    /// - `.Trailing`: `offset` is relative to the trailing edge of the overlay.
    ///
    /// - Parameter position: arrow position
    /// - Parameter offset: arrow offset
    func changeArrowPosition(to position: ArrowPosition, offset: CGFloat) {

        guard let arrowUIView = arrowUIView else { return }

        if innerConstraints.arrowXposition != nil {
            self.removeConstraint(innerConstraints.arrowXposition!)
        }

        innerConstraints.arrowXposition = coachMarkLayoutHelper.horizontalArrowConstraints(
            for: (bodyView: bodyUIView, arrowView: arrowUIView), withPosition: position,
            horizontalOffset: offset)

        innerConstraints.arrowXposition?.isActive = true
    }

    // MARK: - Private Method

    /// Layout the body view and the arrow view together.
    private func layoutViewComposition() {
        translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(bodyUIView)
        self.addConstraints(bodyUIView.makeConstraintToFillSuperviewHorizontally())

        if let arrowUIView = arrowUIView, let arrowOrientation = self.arrowOrientation {
            self.addSubview(arrowUIView)

            innerConstraints.arrowXposition = coachMarkLayoutHelper.horizontalArrowConstraints(
                for: (bodyView: bodyUIView, arrowView: arrowUIView), withPosition: .center,
                horizontalOffset: 0)

            innerConstraints.arrowXposition?.isActive = true
            self.addConstraints(coachMarkLayoutHelper.verticalConstraints(
                for: (bodyView: bodyUIView, arrowView: arrowUIView), in: self,
                withProperties: (orientation: arrowOrientation, verticalArrowOffset: arrowOffset)
            ))
        } else {
            bodyUIView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            bodyUIView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }
}

// MARK: - Protocol conformance | CoachMarkBodyHighlightArrowDelegate
extension CoachMarkView: CoachMarkBodyHighlightArrowDelegate {
    func highlightArrow(_ highlighted: Bool) {
        self.arrowView?.isHighlighted = highlighted
    }
}

private struct CoachMarkViewConstraints {
    /// The horizontal position of the arrow, likely to be at the center of the
    /// cutout path.
    var arrowXposition: NSLayoutConstraint?

    /// The constraint making the body stick to its parent.
    var bodyStickToParent: NSLayoutConstraint?

    init () { }
}
