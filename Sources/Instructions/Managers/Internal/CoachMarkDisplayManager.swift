// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// This class deals with the layout of coach marks.
class CoachMarkDisplayManager {
    // MARK: - Public properties
    weak var dataSource: CoachMarksControllerProxyDataSource!
    weak var animationDelegate: CoachMarksControllerAnimationProxyDelegate?
    weak var overlayManager: OverlayManager?

    // MARK: - Private properties
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
        if coachMark.isDisplayedOverCutoutPath {
            // No arrow should be shown when displayed above the cutoutPath.
            return CoachMarkView(bodyView: coachMarkComponentViews.bodyView,
                                 coachMarkInnerLayoutHelper: CoachMarkInnerLayoutHelper())
        } else {
            return CoachMarkView(bodyView: coachMarkComponentViews.bodyView,
                                 arrowView: coachMarkComponentViews.arrowView,
                                 arrowOrientation: coachMark.arrowOrientation,
                                 arrowOffset: coachMark.gapBetweenBodyAndArrow,
                                 coachMarkInnerLayoutHelper: CoachMarkInnerLayoutHelper())
        }
    }

    // TODO: ❗️ Refactor this method into smaller components
    /// Hide the given CoachMark View
    ///
    /// - Parameters:
    ///   - coachMarkView: the coach mark view to show.
    ///   - coachMark: the coach mark metadata
    ///   - index: the current index at which the coach mark is displayed
    ///   - animated: `true` to animate the coach mark appearance,`false` otherwise.
    ///   - beforeTransition: `true` if the coach mark is hidden because a transition
    ///                        is about to happen.
    ///   - completion: a handler to call after the coach mark was successfully hidden.
    func hide(coachMarkView: UIView, from coachMark: CoachMark, at index: Int,
              animated: Bool, beforeTransition: Bool, completion: (() -> Void)? = nil) {
        guard let overlay = overlayManager else { return }

        guard animated else {
            if !beforeTransition {
                overlay.showCutoutPath(false, withDuration: 0)
            }

            coachMarkView.alpha = 0.0
            coachMarkView.removeFromSuperview()
            completion?()

            return
        }

        let transitionManager = CoachMarkTransitionManager(coachMark: coachMark)

        animationDelegate?.fetchDisappearanceTransition(OfCoachMark: coachMarkView, at: index,
                                                        using: transitionManager)

        if !beforeTransition {
            overlay.showCutoutPath(false, withDuration: transitionManager.parameters.duration)
        }

        guard let animations = transitionManager.animations else {
            UIView.animate(withDuration: transitionManager.parameters.duration,
                           animations: { coachMarkView.alpha = 0.0 },
                           completion: { _ in
                coachMarkView.removeFromSuperview()
                completion?()
            })

            return
        }

        let completionBlock: (Bool) -> Void = { success in
            coachMarkView.removeFromSuperview()
            completion?()
            transitionManager.completion?(success)
        }

        let context = transitionManager.createContext()
        let animationBlock = { animations(context) }

        transitionManager.initialState?()

        if transitionManager.animationType == .regular {
            UIView.animate(withDuration: transitionManager.parameters.duration,
                           delay: transitionManager.parameters.delay,
                           options: transitionManager.parameters.options,
                           animations: animationBlock, completion: completionBlock)
        } else {
            UIView.animateKeyframes(withDuration: transitionManager.parameters.duration,
                                    delay: transitionManager.parameters.delay,
                                    options: transitionManager.parameters.keyframeOptions,
                                    animations: animationBlock, completion: completionBlock)
        }
    }

    // TODO: ❗️ Refactor this method into smaller components
    /// Display the given CoachMark View
    ///
    /// - Parameters:
    ///   - coachMarkView: the coach mark view to show.
    ///   - coachMark: the coach mark metadata
    ///   - index: the current index at which the coach mark is displayed
    ///   - animated: `true` to animate the coach mark appearance,`false` otherwise.
    ///   - beforeTransition: `true` if the coach mark is hidden because a transition
    ///                        is about to happen.
    ///   - completion: a handler to call after the coach mark was successfully displayed.
    func showNew(coachMarkView: CoachMarkView, from coachMark: CoachMark,
                 at index: Int, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let overlay = overlayManager else { return }

        prepare(coachMarkView: coachMarkView, forDisplayIn: overlay.overlayView.superview!,
                usingCoachMark: coachMark, andOverlayView: overlay.overlayView)

        overlay.enableTap = coachMark.isOverlayInteractionEnabled
        overlay.isUserInteractionEnabledInsideCutoutPath =
            coachMark.isUserInteractionEnabledInsideCutoutPath

        guard animated else {
            overlay.showCutoutPath(true, withDuration: 0)
            coachMarkView.alpha = 1.0
            completion?()
            return
        }

        let transitionManager = CoachMarkTransitionManager(coachMark: coachMark)

        animationDelegate?.fetchAppearanceTransition(OfCoachMark: coachMarkView, at: index,
                                                     using: transitionManager)

        overlay.showCutoutPath(true, withDuration: transitionManager.parameters.duration)

        guard let animations = transitionManager.animations else {
            // The view shall be invisible, 'cause we'll animate its entry.
            coachMarkView.alpha = 0.0

            UIView.animate(withDuration: transitionManager.parameters.duration,
                           animations: { coachMarkView.alpha = 1.0 },
                           completion: { [weak self] _ in
                completion?()
                self?.applyIdleAnimation(to: coachMarkView, from: coachMark, at: index)
            })

            return
        }

        let completionBlock: (Bool) -> Void = { [weak self] success in
            completion?()
            transitionManager.completion?(success)
            self?.applyIdleAnimation(to: coachMarkView, from: coachMark, at: index)
        }

        let context = transitionManager.createContext()
        let animationBlock = { animations(context) }

        transitionManager.initialState?()

        if transitionManager.animationType == .regular {
            UIView.animate(withDuration: transitionManager.parameters.duration,
                           delay: transitionManager.parameters.delay,
                           options: transitionManager.parameters.options,
                           animations: animationBlock, completion: completionBlock)
        } else {
            UIView.animateKeyframes(withDuration: transitionManager.parameters.duration,
                                    delay: transitionManager.parameters.delay,
                                    options: transitionManager.parameters.keyframeOptions,
                                    animations: animationBlock, completion: completionBlock)
        }
    }

    // MARK: - Private methods
    /// Add the current coach mark to the view, making sure it is
    /// properly positioned.
    ///
    /// - Parameters:
    ///   - coachMarkView: the coach mark to display
    ///   - parentView: the view in which display coach marks
    ///   - coachMark: the coachmark data
    ///   - overlayView: the overlayView (covering everything and showing cutouts)
    private func prepare(coachMarkView: CoachMarkView, forDisplayIn parentView: UIView,
                         usingCoachMark coachMark: CoachMark,
                         andOverlayView overlayView: OverlayView) {
        // Add the view and compute its associated constraints.
        parentView.addSubview(coachMarkView)

        coachMarkView.widthAnchor
                     .constraint(lessThanOrEqualToConstant: coachMark.maxWidth).isActive = true

        // No cutoutPath, no arrow.
        if let cutoutPath = coachMark.cutoutPath {

            generateAndEnableVerticalConstraints(of: coachMarkView, forDisplayIn: parentView,
                                                 usingCoachMark: coachMark, cutoutPath: cutoutPath,
                                                 andOverlayView: overlayView)

            generateAndEnableHorizontalConstraints(of: coachMarkView, forDisplayIn: parentView,
                                                  usingCoachMark: coachMark,
                                                  andOverlayView: overlayView)

            overlayView.cutoutPath = cutoutPath
        } else {
            overlayView.cutoutPath = nil
        }
    }

    /// Generate the vertical constraints needed to lay out `coachMarkView` above or below the
    /// cutout path.
    ///
    /// - Parameters:
    ///   - coachMarkView: the coach mark to display
    ///   - parentView: the view in which display coach marks
    ///   - coachMark: the coachmark data
    ///   - cutoutPath: the cutout path
    ///   - overlayView: the overlayView (covering everything and showing cutouts)
    private func generateAndEnableVerticalConstraints(of coachMarkView: CoachMarkView,
                                                      forDisplayIn parentView: UIView,
                                                      usingCoachMark coachMark: CoachMark,
                                                      cutoutPath: UIBezierPath,
                                                      andOverlayView overlayView: OverlayView) {
        let offset = coachMark.gapBetweenCoachMarkAndCutoutPath

        // Depending where the cutoutPath sits, the coach mark will either
        // stand above or below it. Alternatively, it can also be displayed
        // over the cutoutPath.
        if coachMark.isDisplayedOverCutoutPath {
            let constant = cutoutPath.bounds.midY - parentView.frame.size.height / 2

            coachMarkView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor,
                                                   constant: constant).isActive = true
        } else if coachMark.arrowOrientation! == .bottom {
            let constant = -(parentView.frame.size.height -
                cutoutPath.bounds.origin.y + offset)

            coachMarkView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor,
                                                  constant: constant).isActive = true
        } else {
            let constant = (cutoutPath.bounds.origin.y +
                cutoutPath.bounds.size.height) + offset

            coachMarkView.topAnchor.constraint(equalTo: parentView.topAnchor,
                                               constant: constant).isActive = true
        }
    }

    /// Generate horizontal constraints needed to lay out `coachMarkView` at the
    /// right place. This method uses a two-pass mechanism, whereby the `coachMarkView` is
    /// at first laid out around the center of the point of interest. If it turns out
    /// that the `coachMarkView` is partially out of the bounds of its parent (margins included),
    /// the view is laid out again using the 3-segment mechanism.
    ///
    /// - Parameters:
    ///   - coachMarkView: the coach mark to display
    ///   - parentView: the view in which display coach marks
    ///   - coachMark: the coachmark data
    ///   - overlayView: the overlayView (covering everything and showing cutouts)
    private func generateAndEnableHorizontalConstraints(of coachMarkView: CoachMarkView,
                                                        forDisplayIn parentView: UIView,
                                                        usingCoachMark coachMark: CoachMark,
                                                        andOverlayView overlayView: OverlayView) {
        // Generating the constraints for the first pass. This constraints center
        // the view around the point of interest.
        let constraints = coachMarkLayoutHelper.constraints(for: coachMarkView,
                                                            coachMark: coachMark,
                                                            parentView: parentView)

        // Laying out the view
        parentView.addConstraints(constraints)
        parentView.setNeedsLayout()
        parentView.layoutIfNeeded()

        // If the view turns out to be partially outside of the screen, constraints are
        // computed again and the view is laid out for the second time.
        let insets = UIEdgeInsets(top: 0, left: coachMark.horizontalMargin,
                                  bottom: 0, right: coachMark.horizontalMargin)

        if coachMarkView.isOutOfSuperview(consideringInsets: insets) {
            // Removing previous constraints.
            for constraint in constraints {
                parentView.removeConstraint(constraint)
            }

            let constraints = coachMarkLayoutHelper.constraints(for: coachMarkView,
                                                                coachMark: coachMark,
                                                                parentView: parentView,
                                                                passNumber: 1)

            parentView.addConstraints(constraints)
        }
    }

    /// Fetch and perform user-defined idle animation on given coach mark view.
    ///
    /// - Parameters:
    ///   - coachMarkView: the view to animate.
    ///   - coachMark: the related coach mark metadata.
    ///   - index: the index of the coach mark.
    private func applyIdleAnimation(to coachMarkView: UIView, from coachMark: CoachMark,
                                    at index: Int) {
        let transitionManager = CoachMarkAnimationManager(coachMark: coachMark)

        animationDelegate?.fetchIdleAnimationOfCoachMark(OfCoachMark: coachMarkView, at: index,
                                                         using: transitionManager)

        if let animations = transitionManager.animations {
            let context = transitionManager.createContext()
            let animationBlock = { animations(context) }

            if transitionManager.animationType == .regular {
                UIView.animate(withDuration: transitionManager.parameters.duration,
                               delay: transitionManager.parameters.delay,
                               options: transitionManager.parameters.options,
                               animations: animationBlock, completion: nil)
            } else {
                UIView.animateKeyframes(withDuration: transitionManager.parameters.duration,
                                        delay: transitionManager.parameters.delay,
                                        options: transitionManager.parameters.keyframeOptions,
                                        animations: animationBlock, completion: nil)
            }
        }
    }
}
