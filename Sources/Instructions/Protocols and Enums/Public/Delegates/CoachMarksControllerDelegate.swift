// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// Give a chance to react when coach marks are displayed
public protocol CoachMarksControllerDelegate: AnyObject {
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              configureOrnamentsOfOverlay overlay: UIView)

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              willLoadCoachMarkAt index: Int) -> Bool

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              willShow coachMark: inout CoachMark,
                              beforeChanging change: ConfigurationChange,
                              at index: Int)

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didShow coachMark: CoachMark,
                              afterChanging change: ConfigurationChange,
                              at index: Int)

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              willHide coachMark: CoachMark,
                              at index: Int)

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didHide coachMark: CoachMark,
                              at index: Int)

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didEndShowingBySkipping skipped: Bool)

    func shouldHandleOverlayTap(in coachMarksController: CoachMarksController,
                                at index: Int) -> Bool
}

public extension CoachMarksControllerDelegate {
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              configureOrnamentsOfOverlay overlay: UIView) { }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              willLoadCoachMarkAt index: Int) -> Bool {
        return true
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              willShow coachMark: inout CoachMark,
                              afterSizeTransition: Bool,
                              at index: Int) { }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didShow coachMark: CoachMark,
                              afterSizeTransition: Bool,
                              at index: Int) { }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              willShow coachMark: inout CoachMark,
                              beforeChanging change: ConfigurationChange,
                              at index: Int) { }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didShow coachMark: CoachMark,
                              afterChanging change: ConfigurationChange,
                              at index: Int) { }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              willHide coachMark: CoachMark,
                              at index: Int) { }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didHide coachMark: CoachMark,
                              at index: Int) { }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didEndShowingBySkipping skipped: Bool) { }

    func shouldHandleOverlayTap(in coachMarksController: CoachMarksController,
                                at index: Int) -> Bool {
        return true
    }
}

protocol CoachMarksControllerProxyDelegate: AnyObject {
    func configureOrnaments(ofOverlay: UIView)

    func willLoadCoachMark(at index: Int) -> Bool

    func willShow(coachMark: inout CoachMark, afterSizeTransition: Bool, at index: Int)

    func didShow(coachMark: CoachMark, afterSizeTransition: Bool, at index: Int)

    func willShow(coachMark: inout CoachMark, beforeChanging change: ConfigurationChange,
                  at index: Int)

    func didShow(coachMark: CoachMark, afterChanging change: ConfigurationChange, at index: Int)

    func willHide(coachMark: CoachMark, at index: Int)

    func didHide(coachMark: CoachMark, at index: Int)

    func didEndShowingBySkipping(_ skipped: Bool)

    func shouldHandleOverlayTap(at index: Int) -> Bool
}
