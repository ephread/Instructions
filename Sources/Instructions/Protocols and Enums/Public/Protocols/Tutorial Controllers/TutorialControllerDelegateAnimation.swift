// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// No overview available 😅
public protocol TutorialControllerDelegateAnimation: TutorialControllerDelegate {
    /// No overview available 😅
    func tutorialController(
        _ tutorialController: TutorialController,
        willDisplayCoachMark coachMark: UIView,
        at index: Int,
        transitioner: CoachMarkTransitionManager
    )

    /// No overview available 😅
    func tutorialController(
        _ tutorialController: TutorialController,
        willEndDisplayingCoachMark coachMark: UIView,
        at index: Int,
        transitioner: CoachMarkTransitionManager
    )

    /// No overview available 😅
    func tutorialController(
        _ tutorialController: TutorialController,
        animateCoachMark coachMark: UIView,
        at index: Int,
        animator: CoachMarkAnimationManager
    )
}

// MARK: -
/// No overview available 😅
public extension TutorialControllerDelegateAnimation {
    /// No overview available 😅
    func tutorialController(
        _ tutorialController: TutorialController,
        willDisplayCoachMark coachMark: UIView,
        at index: Int,
        transitioner: CoachMarkTransitionManager
    ) { }

    /// No overview available 😅
    func tutorialController(
        _ tutorialController: TutorialController,
        willEndDisplayingCoachMark coachMark: UIView,
        at index: Int,
        transitioner: CoachMarkTransitionManager
    ) { }

    /// No overview available 😅
    func tutorialController(
        _ tutorialController: TutorialController,
        animateCoachMark coachMark: UIView,
        at index: Int,
        animator: CoachMarkAnimationManager
    ) { }
}
