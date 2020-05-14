// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// Describe how a coachmark datasource should behave.
/// It works a bit like `UITableViewDataSource`.
public protocol CoachMarksControllerDataSource: AnyObject {
    /// Asks for the number of coach marks to display.
    ///
    /// - Parameter coachMarksController: the coach mark controller requesting
    ///                                   the information.
    ///
    /// - Returns: the number of coach marks to display.
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int

    /// Asks for the metadata of the coach mark that will be displayed in the
    /// given nth place. All `CoachMark` metadata are optional or filled with
    /// sensible defaults. You are not forced to provide the `cutoutPath`.
    /// If you don't the coach mark will be dispayed at the bottom of the screen,
    /// without an arrow.
    ///
    /// - Parameter coachMarksController: the coach mark controller requesting
    ///                                   the information.
    /// - Parameter coachMarkViewsForIndex: the index referring to the nth place.
    ///
    /// - Returns: the coach mark metadata.
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark

    /// Asks for the views defining the coach mark that will be displayed in
    /// the given nth place. The arrow view is optional. However, if you provide
    /// one, you are responsible for supplying the proper arrow orientation.
    /// The expected orientation is available through
    /// `coachMark.arrowOrientation` and was computed beforehand.
    ///
    /// - Parameter coachMarksController: the coach mark controller requesting
    ///                                   the information.
    /// - Parameter coachMarkViewsForIndex: the index referring to the nth place.
    /// - Parameter coachMark: the coach mark meta data.
    ///
    /// - Returns: a tuple packaging the body component and the arrow component.
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark)
    -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?)

    /// Asks for autolayout constraints needed to position `skipView` in
    /// `coachMarksController.view`.
    ///
    /// - Parameter coachMarksController: the coach mark controller requesting
    ///                                   the information.
    /// - Parameter skipView: the view holding the skip button.
    /// - Parameter inParentView: the parent view (used to set contraints properly).
    ///
    /// - Returns: an array of NSLayoutConstraint.
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              constraintsForSkipView skipView: UIView,
                              inParent parentView: UIView) -> [NSLayoutConstraint]?
}

public extension CoachMarksControllerDataSource {
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              constraintsForSkipView skipView: UIView,
                              inParent parentView: UIView) -> [NSLayoutConstraint]? {
        return nil
    }
}

internal protocol CoachMarksControllerProxyDataSource: AnyObject {
    /// Asks for the number of coach marks to display.
    ///
    /// - Returns: the number of coach marks to display.
    func numberOfCoachMarks() -> Int

    /// Asks for the metadata of the coach mark that will be displayed in the
    /// given nth place. All `CoachMark` metadata are optional or filled with
    /// sensible defaults. You are not forced to provide the `cutoutPath`.
    /// If you don't the coach mark will be dispayed at the bottom of the screen,
    /// without an arrow.
    ///
    /// - Parameter index: the index referring to the nth place.
    ///
    /// - Returns: the coach mark metadata.
    func coachMark(at index: Int) -> CoachMark

    /// Asks for the views defining the coach mark that will be displayed in
    /// the given nth place. The arrow view is optional. However, if you provide
    /// one, you are responsible for supplying the proper arrow orientation.
    /// The expected orientation is available through
    /// `coachMark.arrowOrientation` and was computed beforehand.
    ///
    /// - Parameter coachMarkViewsForIndex: the index referring to the nth place.
    /// - Parameter coachMark: the coach mark meta data.
    ///
    /// - Returns: a tuple packaging the body component and the arrow component.
    func coachMarkViews(at index: Int, madeFrom coachMark: CoachMark)
        -> (bodyView: UIView & CoachMarkBodyView, arrowView: (UIView & CoachMarkArrowView)?)

    /// Asks for autolayout constraints needed to position `skipView` in
    /// `coachMarksController.view`.
    ///
    /// - Parameter skipView: the view holding the skip button.
    /// - Parameter inParentView: the parent view (used to set contraints properly).
    ///
    /// - Returns: an array of NSLayoutConstraint.
    func constraintsForSkipView(_ skipView: UIView,
                                inParent parentView: UIView) -> [NSLayoutConstraint]?
}
