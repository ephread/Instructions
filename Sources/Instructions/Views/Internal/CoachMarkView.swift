// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

// swiftlint:disable force_cast

/// The actual coach mark that will be displayed.
class CoachMarkView: UIView {
    // MARK: - Internal properties
    let container: CoachMarkViewComponents

    /// The arrow orientation (where it will sit relative to the body view, i.e.
    /// above or below.)
    let verticalPosition: ComputedVerticalPosition

    /// The offset (in case the arrow is required to overlap the body)
    var pointerOffset: CGFloat

    var pointerAlignmentConstraint: NSLayoutConstraint?

    /// The control used to get to the next coach mark.
    var nextControl: UIControl? {
        return container.content.nextControl
    }

    // MARK: - Private properties
    private let coachMarkLayoutHelper: CoachMarkInnerLayoutHelper

    // MARK: - Initialization

    /// Allocate and initialize the coach mark view, with the given subviews.
    ///
    /// - Parameter contentView:         the mandatory body view
    /// - Parameter pointerView:        the optional arrow view
    /// - Parameter arrowOrientation: the arrow orientation, either .Top or .Bottom
    /// - Parameter arrowOffset:      the arrow offset (in case the arrow is required
    ///                               to overlap the body) - a positive number
    ///                               will make the arrow overlap.
    /// - Parameter coachMarkInnerLayoutHelper: auto-layout constraints helper.
    init(
        container: CoachMarkViewComponents,
        verticalPosition: ComputedVerticalPosition,
        pointerOffset: CGFloat? = nil,
        coachMarkInnerLayoutHelper: CoachMarkInnerLayoutHelper
    ) {
        self.container = container
        self.verticalPosition = verticalPosition
        self.coachMarkLayoutHelper = coachMarkInnerLayoutHelper
        self.pointerOffset = pointerOffset ?? 0.0

        super.init(frame: CGRect.zero)

        self.container.content.onHighlight = { [weak self] isHighlighted in
            self?.container.pointer?.isHighlighted = isHighlighted
        }

        self.layoutViewComposition()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError(ErrorMessage.Fatal.doesNotSupportNSCoding)
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
    func changeArrowAlignment(to alignment: HorizontalAlignment, offset: CGFloat) {
        guard let pointer = container.pointer else { return }

        pointerAlignmentConstraint?.isActive = false
        pointerAlignmentConstraint = coachMarkLayoutHelper.makeHorizontalPointerConstraints(
            content: container.content,
            pointer: pointer,
            alignment: alignment,
            offset: offset
        )

        pointerAlignmentConstraint?.isActive = true
    }

    // MARK: - Private Method

    /// Layout the body view and the arrow view together.
    private func layoutViewComposition() {
        translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(container.content)
        container.content.fillSuperviewHorizontally()

        if let pointer = container.pointer,
           verticalPosition != .over {
            self.addSubview(pointer)

            pointerAlignmentConstraint = coachMarkLayoutHelper.makeHorizontalPointerConstraints(
                content: container.content,
                pointer: pointer,
                alignment: .center,
                offset: 0
            )

            let constraints = coachMarkLayoutHelper.makeVerticalConstraints(
                content: container.content,
                pointer: pointer,
                parent: self,
                position: verticalPosition,
                offset: pointerOffset
            )

            pointerAlignmentConstraint?.isActive = true
            NSLayoutConstraint.activate(constraints)
        } else {
            container.content.topAnchor.constraint(equalTo: topAnchor).isActive = true
            container.content.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }
}
