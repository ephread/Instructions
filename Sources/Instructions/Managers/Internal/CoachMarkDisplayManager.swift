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
class CoachMarkDisplayManager {
    // MARK: - Public properties
    weak var dataSource: CoachMarksControllerProxyDataSource!

    // MARK: - Private properties
    /// The coach mark metadata
    private var coachMark: CoachMark!

    /// The coach mark view (the one displayed)
    private var coachMarkView: CoachMarkView!

    private let coachMarkLayoutHelper: CoachMarkLayoutHelper

    // MARK: - Initialization
    /// Allocate and initialize the manager.
    ///
    /// - Parameter coachMarkLayoutHelper: auto-layout constraint generator
    init(coachMarkLayoutHelper: CoachMarkLayoutHelper) {
        self.coachMarkLayoutHelper = coachMarkLayoutHelper
    }

    func createCoachMarkView(from coachMark: CoachMark, at index: Int) -> CoachMarkView {
        // Asks the data source for the appropriate tuple of views.
        let coachMarkComponentViews =
            dataSource.coachMarkViews(at: index, madeFrom: coachMark)

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
    func hide(coachMarkView: UIView?, overlay: OverlayManager, animationDuration: TimeInterval,
              beforeTransition: Bool, completion: (() -> Void)? = nil) {
        if !beforeTransition {
            overlay.showCutoutPath(false, withDuration: animationDuration)
        }

        coachMarkView?.layer.removeAllAnimations()
        //removeTargetFromCurrentCoachView()

        if animationDuration == 0 {
            coachMarkView?.alpha = 0.0
            coachMarkView?.removeFromSuperview()
            completion?()
        } else {
            UIView.animate(withDuration: animationDuration, animations: { () -> Void in
                coachMarkView?.alpha = 0.0
            }, completion: { _ in
                coachMarkView?.removeFromSuperview()
                completion?()
            })
        }
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
    func showNew(coachMarkView: CoachMarkView, from coachMark: CoachMark,
                 on overlay: OverlayManager, animated: Bool = true,
                 completion: (() -> Void)? = nil) {
        prepare(coachMarkView: coachMarkView, forDisplayIn: overlay.overlayView.superview!,
                usingCoachMark: coachMark, andOverlayView: overlay.overlayView)

        overlay.enableTap = !coachMark.disableOverlayTap
        overlay.allowTouchInsideCutoutPath = coachMark.allowTouchInsideCutoutPath

        // The view shall be invisible, 'cause we'll animate its entry.
        coachMarkView.alpha = 0.0

        // Animate the view entry
        overlay.showCutoutPath(true, withDuration: coachMark.animationDuration)

        if animated {
            UIView.animate(withDuration: coachMark.animationDuration, animations: { () -> Void in
                coachMarkView.alpha = 1.0
            }, completion: { _ in
                completion?()
            })
        } else {
            coachMarkView.alpha = 1.0
            completion?()
        }
    }

    // MARK: - Private methods

    /// Store the necessary data (rather than passing them across all private
    /// methods.)
    ///
    /// - Parameter coachMark: the coach mark metadata
    /// - Parameter coachMarkView: the coach mark view (the one displayed)
    /// - Parameter overlayView: the overlayView (covering everything and showing cutouts)
    /// - Parameter instructionsRootView: the view holding the coach marks
    fileprivate func store(coachMark: CoachMark, coachMarkView: CoachMarkView,
                           overlayView: OverlayView, instructionsRootView: UIView) {
        self.coachMark = coachMark
        self.coachMarkView = coachMarkView
    }

    /// Clear the stored data.
    fileprivate func clearStoredData() {
        coachMark = nil
        coachMarkView = nil
    }

    /// Add the current coach mark to the view, making sure it is
    /// properly positioned.
    ///
    /// - Parameter coachMarkView: the coach mark to display
    /// - Parameter parentView: the view in which display coach marks
    /// - Parameter coachMark: the coachmark data
    /// - Parameter overlayView: the overlayView (covering everything and showing cutouts)
    fileprivate func prepare(coachMarkView: CoachMarkView, forDisplayIn parentView: UIView,
                             usingCoachMark coachMark: CoachMark,
                             andOverlayView overlayView: OverlayView) {
        // Add the view and compute its associated constraints.
        parentView.addSubview(coachMarkView)

        parentView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:[currentCoachMarkView(<=\(coachMark.maxWidth))]",
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
            if coachMark.arrowOrientation! == .bottom {
                let constant = -(parentView.frame.size.height -
                                 cutoutPath.bounds.origin.y + offset)

                let coachMarkViewConstraint =
                    coachMarkView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor,
                                                          constant: constant)

                parentView.addConstraint(coachMarkViewConstraint)
            } else {
                let constant = (cutoutPath.bounds.origin.y +
                                cutoutPath.bounds.size.height) + offset

                let coachMarkViewConstraint =
                    coachMarkView.topAnchor.constraint(equalTo: parentView.topAnchor,
                                                       constant: constant)

                parentView.addConstraint(coachMarkViewConstraint)
            }

            let constraints = coachMarkLayoutHelper.constraints(for: coachMarkView,
                                                                coachMark: coachMark,
                                                                parentView: parentView)

            parentView.addConstraints(constraints)
            overlayView.cutoutPath = cutoutPath
        } else {
            overlayView.cutoutPath = nil
        }
    }
}
