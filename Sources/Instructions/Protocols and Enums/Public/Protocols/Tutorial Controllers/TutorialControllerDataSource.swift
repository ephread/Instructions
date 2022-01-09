// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// The methods that an object adopts to provide coach marks for a tutorial.
public protocol TutorialControllerDataSource: AnyObject {
    /// Tells the data source to return the number of rows in a given section of a table view.
    ///
    /// - Parameter tutorialController: The tutorial controller requesting this information.
    /// - Returns: The number of coach marks in `tutorialController`.
    func numberOfCoachMarks(in tutorialController: TutorialController) -> Int

    /// Asks the data source for a coach mark to display at the given ordinal position.
    ///
    /// - Parameter tutorialController: The tutorial controller requesting this information.
    /// - Parameter index: An index defining the ordinal position of the coach mark.
    ///
    /// - Returns: A ``CoachMark`` containing appropriate metadata.
    func tutorialController(
        _ tutorialController: TutorialController,
        configurationForCoachMarkAt index: Int
    ) -> CoachMarkConfiguration

    /// Asks the data source for the views making up the coach mark at the given ordinal position.
    ///
    /// - Parameter tutorialController: The coach mark controller requesting the information.
    /// - Parameter index: The index referring to the nth place.
    /// - Parameter coachMark: The coach mark meta data.
    ///
    /// - Returns: An instance of ``CoachMarkCompoundView`` containing the content view of the
    ///            coach mark and, if applicable, its pointer view.
    func tutorialController(
        _ tutorialController: TutorialController,
        compoundViewFor configuration: ComputedCoachMarkConfiguration,
        at index: Int
    ) -> CoachMarkViewComponents
}
