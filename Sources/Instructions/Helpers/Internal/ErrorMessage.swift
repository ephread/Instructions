// Copyright (c) 2020-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import Foundation

struct ErrorMessage {
    struct Info {
        static let nilPointOfInterestZeroOffset =
            "[INFO] The point of interest is nil, offset will be zero."

        static let nilPointOfInterestCenterAlignment =
            "[INFO] The point of interest is nil, alignment will fall back to .center."

        static let skipViewNoSuperviewNotShown =
            "[INFO] skipView has no superview and won't be shown."

        static let skipViewNoSuperviewNotUpdated =
            "[INFO] skipView has no superview and won't be updated."
    }

    struct Warning {
        static let unsupportedWindowLevel =
            "[WARNING] Displaying Instructions over the status bar is unsupported in iOS 13+."

        static let nilDataSource =
            "[WARNING] dataSource is nil."

        static let noCoachMarks =
            "[WARNING] dataSource.numberOfCoachMarks(for:) returned 0."

        static let noParent =
            "[WARNING] View has no parent, cannot define constraints."

        static let frameWithNoWidth =
           "[WARNING] frame has no width, alignment will fall back to .center."

        static let negativeNumberOfCoachMarksToSkip =
           "[WARNING] numberToSkip is negative, ignoring."
    }

    struct Error {
        static let couldNotBeAttached =
            """
            [ERROR] Instructions could not be properly attached to the window \
            did you call `start(in:)` inside `viewDidLoad` instead of `viewDidAppear`?
            """

        static let notAChild =
            """
            [WARNING] `coachMarkView` is not a child of `parentView`. \
            The array of constraints will be empty.
            """

        static let updateWentWrong =
            """
            [ERROR] Something went wrong, did you call \
            `updateCurrentCoachMark()` without pausing the controller first?
            """

        static let overlayEmptyBounds =
            """
            [ERROR] The overlay view added to the window has empty bounds, \
            Instructions will stop.
            """
    }

    struct Fatal {
        static let negativeNumberOfCoachMarks =
            "dataSource.numberOfCoachMarks(for:) returned a negative number."

        static let windowContextNotAvailableInAppExtensions =
            "PresentationContext.newWindow(above:) is not available in App Extensions."

        static let doesNotSupportNSCoding =
            "This class does not support NSCoding."
    }
}
