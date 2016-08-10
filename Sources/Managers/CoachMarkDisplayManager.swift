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
    weak var dataSource: CoachMarksControllerProxyDataSource!

    //MARK: - Private properties
    /// The coach mark metadata
    private var coachMark: CoachMark!

    /// The coach mark view (the one displayed)
    private var coachMarkView: CoachMarkView!

    private let coachMarkLayoutHelper: CoachMarkLayoutHelper

    //MARK: - Initialization
    /// Allocate and initialize the manager.
    ///
    /// - Parameter coachMarkLayoutHelper: auto-layout constraint generator
    init(coachMarkLayoutHelper: CoachMarkLayoutHelper) {
        self.coachMarkLayoutHelper = coachMarkLayoutHelper
    }

    func createCoachMarkViewFromCoachMark(coachMark: CoachMark,
                                          withIndex index: Int) -> CoachMarkView {
        // Asks the data source for the appropriate tuple of views.
        let coachMarkComponentViews =
            dataSource.coachMarkViewsForIndex(index,
                                              coachMark: coachMark)

        // Creates the CoachMarkView, from the supplied component views.
        // CoachMarkView() is not a failable initializer. We'll force unwrap
        // currentCoachMarkView everywhere.
        return CoachMarkView(bodyView: coachMarkComponentViews.bodyView,
                             arrowView: coachMarkComponentViews.arrowView,
                             arrowOrientation: coachMark.arrowOrientation,
                             arrowOffset: coachMark.gapBetweenBodyAndArrow,
                             coachMarkInnerLayoutHelper: CoachMarkInnerLayoutHelper())
    }

    /// Hides the given CoachMark View
    ///
    /// - Parameter coachMarkView: the coach mark to hide
    /// - Parameter overlayView: the overlay to which update the cutout path
    /// - Parameter animationDuration: the duration of the fade
    /// - Parameter completion: a block to execute after the coach mark was hidden
    func hideCoachMarkView(coachMarkView: UIView?, overlayView: OverlayView,
                           animationDuration: NSTimeInterval, completion: (() -> Void)? = nil) {
        overlayView.showCutoutPathView(false, withAnimationDuration: animationDuration)
        coachMarkView?.layer.removeAllAnimations()
        //removeTargetFromCurrentCoachView()

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
    /// - Parameter overlayView: the overlay to which update the cutout path
    /// - Parameter noAnimation: `true` to skip animating the coach mark
    ///                          visibility, `false` otherwise.
    /// - Parameter completion: a handler to call after the coach mark
    ///                         was successfully displayed.
    func showCoachMarkView(coachMarkView: CoachMarkView, from coachMark: CoachMark,
                           overlayView: OverlayView, noAnimation: Bool = false,
                           completion: (() -> Void)? = nil) {
        prepareCoachMarkViewForDisplay(coachMarkView,
            in: overlayView.superview!,
            coachMark: coachMark,
            overlayView: overlayView
        )

        overlayView.enableTap = !coachMark.disableOverlayTap
        overlayView.allowTouchInsideCutoutPath = coachMark.allowTouchInsideCutoutPath

        // The view shall be invisible, 'cause we'll animate its entry.
        coachMarkView.alpha = 0.0

        // Animate the view entry
        overlayView.showCutoutPathView(true, withAnimationDuration: coachMark.animationDuration)

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
    /// - Parameter instructionsRootView: the view holding the coach marks
    private func storeCoachMark(coachMark: CoachMark, coachMarkView: CoachMarkView,
                                overlayView: OverlayView, instructionsRootView: UIView) {
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
    ///
    /// - Parameter coachMarkView: the coach mark to display
    /// - Parameter parentView: the view in whci display coach marks
    /// - Parameter coachMark: the coachmark data
    /// - Parameter overlayView: the overlayView (covering everything and showing cutouts)
    private func prepareCoachMarkViewForDisplay(coachMarkView: CoachMarkView,
                                                in parentView: UIView,
                                                    coachMark: CoachMark,
                                                  overlayView: OverlayView) {
        // Add the view and compute its associated constraints.
        parentView.addSubview(coachMarkView)

        parentView.addConstraints(
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
                let constant = -(parentView.frame.size.height -
                                 cutoutPath.bounds.origin.y + offset)

                let coachMarkViewConstraint = NSLayoutConstraint(
                    item: coachMarkView, attribute: .Bottom, relatedBy: .Equal,
                    toItem: parentView, attribute: .Bottom,
                    multiplier: 1, constant: constant
                )

                parentView.addConstraint(coachMarkViewConstraint)
            } else {
                let constant = (cutoutPath.bounds.origin.y +
                                cutoutPath.bounds.size.height) + offset

                let coachMarkViewConstraint = NSLayoutConstraint(
                    item: coachMarkView, attribute: .Top, relatedBy: .Equal,
                    toItem: parentView, attribute: .Top,
                    multiplier: 1, constant: constant
                )

                parentView.addConstraint(coachMarkViewConstraint)
            }

            let constraints = coachMarkLayoutHelper.constraintsForCoachMarkView(
                coachMarkView,
                coachMark: coachMark,
                parentView: parentView
            )

            parentView.addConstraints(constraints)
            overlayView.updateCutoutPath(cutoutPath)
        } else {
            overlayView.updateCutoutPath(nil)
        }
    }
}
