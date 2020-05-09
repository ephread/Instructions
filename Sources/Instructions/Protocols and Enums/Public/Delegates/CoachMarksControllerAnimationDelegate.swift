// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

///
public protocol CoachMarksControllerAnimationDelegate: AnyObject {
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              fetchAppearanceTransitionOfCoachMark coachMarkView: UIView,
                              at index: Int,
                              using manager: CoachMarkTransitionManager)

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              fetchDisappearanceTransitionOfCoachMark coachMarkView: UIView,
                              at index: Int,
                              using manager: CoachMarkTransitionManager)

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              fetchIdleAnimationOfCoachMark coachMarkView: UIView,
                              at index: Int,
                              using manager: CoachMarkAnimationManager)
}

public extension CoachMarksControllerAnimationDelegate {
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              fetchAppearanceTransitionOfCoachMark coachMarkView: UIView,
                              at index: Int,
                              using manager: CoachMarkTransitionManager) { }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              fetchDisappearanceTransitionOfCoachMark coachMarkView: UIView,
                              at index: Int,
                              using manager: CoachMarkTransitionManager) { }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              fetchIdleAnimationOfCoachMark coachMarkView: UIView,
                              at index: Int,
                              using manager: CoachMarkAnimationManager) { }
}

protocol CoachMarksControllerAnimationProxyDelegate: AnyObject {
    func fetchAppearanceTransition(OfCoachMark coachMarkView: UIView,
                                   at index: Int,
                                   using manager: CoachMarkTransitionManager)

    func fetchDisappearanceTransition(OfCoachMark coachMarkView: UIView,
                                      at index: Int,
                                      using manager: CoachMarkTransitionManager)

    func fetchIdleAnimationOfCoachMark(OfCoachMark coachMarkView: UIView,
                                       at index: Int,
                                       using manager: CoachMarkAnimationManager)
}
