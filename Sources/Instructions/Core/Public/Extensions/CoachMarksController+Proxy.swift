// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

extension CoachMarksController: CoachMarksControllerProxyDataSource {
    func numberOfCoachMarks() -> Int {
        return dataSource!.numberOfCoachMarks(for: self)
    }

    func coachMark(at index: Int) -> CoachMark {
        return dataSource!.coachMarksController(self, coachMarkAt: index)
    }

    func coachMarkViews(at index: Int, madeFrom coachMark: CoachMark)
        -> (bodyView: UIView & CoachMarkBodyView, arrowView: (UIView & CoachMarkArrowView)?) {
            return dataSource!.coachMarksController(self, coachMarkViewsAt: index,
                                                    madeFrom: coachMark)
    }

    func constraintsForSkipView(_ skipView: UIView,
                                inParent parentView: UIView)
        -> [NSLayoutConstraint]? {
            return dataSource?.coachMarksController(self,
                                                    constraintsForSkipView: skipView,
                                                    inParent: parentView)
    }
}

extension CoachMarksController: CoachMarksControllerProxyDelegate {
    func configureOrnaments(ofOverlay overlay: UIView) {
        delegate?.coachMarksController(self, configureOrnamentsOfOverlay: overlay)
    }

    func willLoadCoachMark(at index: Int) -> Bool {
        guard let delegate = delegate else { return true }

        return delegate.coachMarksController(self, willLoadCoachMarkAt: index)
    }

    func willShow(coachMark: inout CoachMark, afterSizeTransition: Bool, at index: Int) {
        delegate?.coachMarksController(self, willShow: &coachMark,
                                       afterSizeTransition: afterSizeTransition, at: index)
    }

    func didShow(coachMark: CoachMark, afterSizeTransition: Bool, at index: Int) {
        delegate?.coachMarksController(self, didShow: coachMark,
                                       afterSizeTransition: afterSizeTransition, at: index)
    }

    func willShow(coachMark: inout CoachMark, beforeChanging change: ConfigurationChange,
                  at index: Int) {
        delegate?.coachMarksController(self, willShow: &coachMark,
                                       beforeChanging: change, at: index)
    }

    func didShow(coachMark: CoachMark, afterChanging change: ConfigurationChange, at index: Int) {
        delegate?.coachMarksController(self, didShow: coachMark,
                                       afterChanging: change, at: index)
    }

    func willHide(coachMark: CoachMark, at index: Int) {
        delegate?.coachMarksController(self, willHide: coachMark, at: index)
    }

    func didHide(coachMark: CoachMark, at index: Int) {
        delegate?.coachMarksController(self, didHide: coachMark, at: index)
    }

    func didEndShowingBySkipping(_ skipped: Bool) {
        delegate?.coachMarksController(self, didEndShowingBySkipping: skipped)
    }

    func shouldHandleOverlayTap(at index: Int) -> Bool {
        return delegate?.shouldHandleOverlayTap(in: self, at: index) ?? true
    }
}

extension CoachMarksController: CoachMarksControllerAnimationProxyDelegate {
    func fetchAppearanceTransition(OfCoachMark coachMarkView: UIView,
                                   at index: Int,
                                   using manager: CoachMarkTransitionManager) {
        animationDelegate?.coachMarksController(
            self, fetchAppearanceTransitionOfCoachMark: coachMarkView,
            at: index, using: manager
        )
    }

    func fetchDisappearanceTransition(OfCoachMark coachMarkView: UIView,
                                      at index: Int,
                                      using manager: CoachMarkTransitionManager) {
        animationDelegate?.coachMarksController(
            self, fetchDisappearanceTransitionOfCoachMark: coachMarkView,
            at: index, using: manager
        )
    }

    func fetchIdleAnimationOfCoachMark(OfCoachMark coachMarkView: UIView,
                                       at index: Int,
                                       using manager: CoachMarkAnimationManager) {
        animationDelegate?.coachMarksController(self,
                                                fetchIdleAnimationOfCoachMark: coachMarkView,
                                                at: index, using: manager)
    }
}
