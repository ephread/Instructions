// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

/// Used by the CoachMarksViewController to notify user or system related events.
protocol CoachMarksViewControllerDelegate: AnyObject {
    /// The given `coachMarkView` was tapped.
    ///
    /// - Parameter coachMarkView: the view that was tapped.
    func didTap(coachMarkView: CoachMarkView?)

    /// The given `skipView` was tapped.
    ///
    /// - Parameter skipView: the view that was tapped.
    func didTap(skipView: CoachMarkSkipView?)

    /// The delegate should prepare for the upcoming size transition.
    func willTransition()

    /// The delegate should perform action, after for the size transition was completed
    func didTransition(afterChanging change: ConfigurationChange)
}
