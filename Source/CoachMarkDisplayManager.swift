// CoachMarkDisplayManager.swift
//
// Copyright (c) 2015, 2016 Frédéric Maquin <fred@ephread.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

/// This class deals with the layout of coach marks.
internal class CoachMarkDisplayManager {
    //MARK: - Public properties
    weak var dataSource: CoachMarksControllerDataSource!

    unowned let coachMarksController: CoachMarksController

    //MARK: - Private properties
    /// The coach mark metadata
    private var coachMark: CoachMark!

    /// The coach mark view (the one displayed)
    private var coachMarkView: CoachMarkView!

    /// The overlayView (covering everything and showing cutouts)
    private let overlayView: OverlayView

    /// The view holding the coach marks
    private let instructionsTopView: UIView

    //MARK: - Initialization
    /// Allocate and initialize the manager.
    ///
    /// - Parameter coachMarksController: the controller holding the
    ///                                   `coachMarksController`
    /// - Parameter overlayView: the overlayView (covering everything and showing cutouts)
    /// - Parameter instructionsTopView: the view holding the coach marks
    init(coachMarksController: CoachMarksController,
         overlayView: OverlayView,
         instructionsTopView: UIView) {
        self.coachMarksController = coachMarksController
        self.overlayView = overlayView
        self.instructionsTopView = instructionsTopView
    }

    func createCoachMarkViewFromCoachMark(coachMark: CoachMark,
                                          withIndex index: Int) -> CoachMarkView {
        // Asks the data source for the appropriate tuple of views.
        let coachMarkComponentViews =
            dataSource.coachMarksController(coachMarksController,
                                            coachMarkViewsForIndex: index,
                                            coachMark: coachMark)

        // Creates the CoachMarkView, from the supplied component views.
        // CoachMarkView() is not a failable initializer. We'll force unwrap
        // currentCoachMarkView everywhere.
        return CoachMarkView(bodyView: coachMarkComponentViews.bodyView,
                             arrowView: coachMarkComponentViews.arrowView,
                             arrowOrientation: coachMark.arrowOrientation,
                             arrowOffset: coachMark.gapBetweenBodyAndArrow)
    }

    /// Hides the given CoachMark View
    ///
    /// - Parameter coachMarkView: the coach mark to hide
    /// - Parameter animationDuration: the duration of the fade
    /// - Parameter completion: a block to execute after the coach mark was hidden
    func hideCoachMarkView(coachMarkView: UIView?,
                           animationDuration: NSTimeInterval,
                           completion: (() -> Void)? = nil) {
        overlayView.hideCutoutPathViewWithAnimationDuration(animationDuration)

        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            coachMarkView?.alpha = 0.0
        }, completion: {(finished: Bool) -> Void in
            coachMarkView?.removeFromSuperview()
            completion?()
        })
    }

    /// Display the given CoachMark View
    ///
    /// - Parameter coachMarkView: the coach mark view to show
    /// - Parameter coachMark: the coach mark metadata
    /// - Parameter noAnimation: `true` to skip animating the coach mark
    ///                          visibility, `false` otherwise.
    /// - Parameter completion: a handler to call after the coach mark
    ///                         was successfully displayed.
    func displayCoachMarkView(coachMarkView: CoachMarkView,
                              coachMark: CoachMark,
                              noAnimation: Bool = false,
                              completion: (() -> Void)? = nil) {

        storeCoachMark(coachMark, coachMarkView: coachMarkView, overlayView: overlayView,
                            instructionsTopView: instructionsTopView)

        prepareCoachMarkForDisplay()
        overlayView.disableOverlayTap = coachMark.disableOverlayTap
        overlayView.allowTouchInsideCutoutPath = coachMark.allowTouchInsideCutoutPath

        clearStoredData()

        // The view shall be invisible, 'cause we'll animate its entry.
        coachMarkView.alpha = 0.0

        // Animate the view entry
        overlayView.showCutoutPathViewWithAnimationDuration(coachMark.animationDuration)

        if noAnimation {
            coachMarkView.alpha = 1.0
            completion?()
        } else {
            UIView.animateWithDuration(coachMark.animationDuration, animations: { () -> Void in
                coachMarkView.alpha = 1.0
            }, completion: {(finished: Bool) -> Void in
                completion?()
            })
        }
    }

    //MARK: - Private methods

    /// Store the necessary data (rather than passing them across all private
    /// methods.)
    ///
    /// - Parameter coachMark: the coach mark metadata
    /// - Parameter coachMarkView: the coach mark view (the one displayed)
    /// - Parameter overlayView: the overlayView (covering everything and showing cutouts)
    /// - Parameter instructionsTopView: the view holding the coach marks
    private func storeCoachMark(coachMark: CoachMark,
                                coachMarkView: CoachMarkView,
                                overlayView: OverlayView,
                                instructionsTopView: UIView) {
        self.coachMark = coachMark
        self.coachMarkView = coachMarkView
    }

    /// Clear the stored data.
    private func clearStoredData() {
        coachMark = nil
        coachMarkView = nil
    }

    /// Add the current coach mark to the view, making sure it is
    /// properly positioned.
    private func prepareCoachMarkForDisplay() {

        // Add the view and compute its associated constraints.
        instructionsTopView.addSubview(coachMarkView)

        instructionsTopView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[currentCoachMarkView(<=\(coachMark.maxWidth))]",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: ["currentCoachMarkView": coachMarkView]
            )
        )

        // No cutoutPath, no arrow.
        if let cutoutPath = coachMark.cutoutPath {
            let offset = coachMark.gapBetweenCoachMarkAndCutoutPath

            // Depending where the cutoutPath sits, the coach mark will either
            // stand above or below it.
            if coachMark.arrowOrientation! == .Bottom {
                let constant = -(instructionsTopView.frame.size.height -
                                 cutoutPath.bounds.origin.y + offset)

                let coachMarkViewConstraint = NSLayoutConstraint(
                    item: coachMarkView, attribute: .Bottom, relatedBy: .Equal,
                    toItem: instructionsTopView, attribute: .Bottom,
                    multiplier: 1, constant: constant
                )

                instructionsTopView.addConstraint(coachMarkViewConstraint)
            } else {
                let constant = (cutoutPath.bounds.origin.y +
                                cutoutPath.bounds.size.height) + offset

                let coachMarkViewConstraint = NSLayoutConstraint(
                    item: coachMarkView, attribute: .Top, relatedBy: .Equal,
                    toItem: instructionsTopView, attribute: .Top,
                    multiplier: 1, constant: constant
                )

                instructionsTopView.addConstraint(coachMarkViewConstraint)
            }

            positionCoachMarkView()

            overlayView.updateCutoutPath(cutoutPath)
        } else {
            overlayView.updateCutoutPath(nil)
        }
    }

    /// Position the coach mark view.
    /// TODO: Improve the layout system. Make it smarter.
    private func positionCoachMarkView() {
        let layoutDirection: UIUserInterfaceLayoutDirection

        if #available(iOS 9, *) {
            layoutDirection =
                UIView.userInterfaceLayoutDirectionForSemanticContentAttribute(
                    instructionsTopView.semanticContentAttribute
                )
        } else {
            layoutDirection = .LeftToRight
        }

        let segmentIndex = self.computeSegmentIndexForLayoutDirection(layoutDirection)

        let horizontalMargin = coachMark.horizontalMargin
        let maxWidth = coachMark.maxWidth

        switch segmentIndex {
        case 1:
            instructionsTopView.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "H:|-(==\(horizontalMargin))-" +
                    "[currentCoachMarkView(<=\(maxWidth))]" +
                    "-(>=\(horizontalMargin))-|",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: nil,
                    views: ["currentCoachMarkView": coachMarkView])
            )

            let offset = arrowOffsetForLayoutDirection(layoutDirection, segmentIndex: segmentIndex)

            coachMarkView.changeArrowPositionTo(.Leading, offset: offset)
        case 2:
            instructionsTopView.addConstraint(NSLayoutConstraint(
                item: coachMarkView, attribute: .CenterX, relatedBy: .Equal,
                toItem: instructionsTopView, attribute: .CenterX,
                multiplier: 1, constant: 0
            ))

            instructionsTopView.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "H:|-(>=\(horizontalMargin))-" +
                    "[currentCoachMarkView(<=\(maxWidth)@1000)]" +
                    "-(>=\(horizontalMargin))-|",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: nil,
                    views: ["currentCoachMarkView": coachMarkView]
                )
            )

            let offset = arrowOffsetForLayoutDirection(layoutDirection, segmentIndex: segmentIndex)

            coachMarkView.changeArrowPositionTo(.Center, offset: offset)

        case 3:
            instructionsTopView.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "H:|-(>=\(horizontalMargin))-" +
                    "[currentCoachMarkView(<=\(maxWidth))]" +
                    "-(==\(horizontalMargin))-|",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: nil,
                    views: ["currentCoachMarkView": coachMarkView]
                )
            )

            let offset = arrowOffsetForLayoutDirection(layoutDirection, segmentIndex: segmentIndex)

            coachMarkView.changeArrowPositionTo(.Trailing, offset: offset)
        default:
            break
        }
    }

    /// Returns the arrow offset, based on the layout and the
    /// segment in which the coach mark will be.
    ///
    /// - Parameter layoutDirection: the layout direction (RTL or LTR)
    /// - Parameter segmentIndex: the segment index (either 1, 2 or 3)
    private func arrowOffsetForLayoutDirection(layoutDirection: UIUserInterfaceLayoutDirection,
                                               segmentIndex: Int) -> CGFloat {

        let pointOfInterest = coachMark.pointOfInterest!

        var arrowOffset: CGFloat

        switch segmentIndex {
        case 1:
            if layoutDirection == .LeftToRight {
                arrowOffset = pointOfInterest.x - coachMark.horizontalMargin
            } else {
                arrowOffset = instructionsTopView.bounds.size.width -
                              pointOfInterest.x -
                              coachMark.horizontalMargin
            }
        case 2:
            if layoutDirection == .LeftToRight {
                arrowOffset = instructionsTopView.center.x - pointOfInterest.x
            } else {
                arrowOffset = pointOfInterest.x - instructionsTopView.center.x
            }
        case 3:
            if layoutDirection == .LeftToRight {
                arrowOffset = instructionsTopView.bounds.size.width -
                              pointOfInterest.x -
                              coachMark.horizontalMargin
            } else {
                arrowOffset = pointOfInterest.x - coachMark.horizontalMargin
            }

        default:
            arrowOffset = 0
            break
        }

        return arrowOffset
    }

    // swiftlint:disable line_length

    /// Compute the segment index (for now the screen is separated
    /// in three horizontal areas and depending in which one the coach
    /// mark stand, it will be layed out in a different way.
    ///
    /// - Parameter layoutDirection: the layout direction (RTL or LTR)
    ///
    /// - Returns: the segment index (either 1, 2 or 3)
    private func computeSegmentIndexForLayoutDirection(layoutDirection: UIUserInterfaceLayoutDirection) -> Int {
        let pointOfInterest = coachMark.pointOfInterest!
        var segmentIndex = 3 * pointOfInterest.x / instructionsTopView.bounds.size.width

        if layoutDirection == .RightToLeft {
            segmentIndex = 3 - segmentIndex
        }

        return Int(ceil(segmentIndex))
    }
}
