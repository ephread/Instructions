// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// Methods for managing and customizing how coach marks are displayed
/// by a tutorial controller.
public protocol TutorialControllerDelegate: AnyObject {
    func tutorialController(
        _ tutorialController: TutorialController,
        willShowCoachMarkWith configuration: inout CoachMarkConfiguration,
        after configurationChange: ConfigurationChange?,
        at index: Int
    )

    func tutorialController(
        _ tutorialController: TutorialController,
        didShowCoachMarkWith configuration: ComputedCoachMarkConfiguration,
        after configurationChange: ConfigurationChange?,
        at index: Int
    )

    func tutorialController(
        _ tutorialController: TutorialController,
        willHideCoachMarkWith configuration: ComputedCoachMarkConfiguration,
        at index: Int
    )

    func tutorialController(
        _ tutorialController: TutorialController,
        didHideCoachMarkWith configuration: ComputedCoachMarkConfiguration,
        at index: Int
    )

    func tutorialController(
        _ tutorialController: TutorialController,
        didEndTutorialBySkipping skipped: Bool
    )

    func tutorialController(
        _ tutorialController: TutorialController,
        shouldLoadConfigurationForCoachMarkAt index: Int
    ) -> Bool

    func tutorialController(
        _ tutorialController: TutorialController,
        shouldHandleOverlayTapAt index: Int
    ) -> Bool
}

// MARK: Extension
public extension TutorialControllerDelegate {
    func tutorialController(
        _ tutorialController: TutorialController,
        willShowCoachMarkWith configuration: inout CoachMarkConfiguration,
        after configurationChange: ConfigurationChange?,
        at index: Int
    ) { }

    func tutorialController(
        _ tutorialController: TutorialController,
        didShowCoachMarkWith configuration: ComputedCoachMarkConfiguration,
        after configurationChange: ConfigurationChange?,
        at index: Int
    ) { }

    func tutorialController(
        _ tutorialController: TutorialController,
        willHideCoachMarkWith configuration: ComputedCoachMarkConfiguration,
        at index: Int
    ) { }

    func tutorialController(
        _ tutorialController: TutorialController,
        didHideCoachMarkWith configuration: ComputedCoachMarkConfiguration,
        at index: Int
    ) { }

    func tutorialController(
        _ tutorialController: TutorialController,
        didEndTutorialBySkipping skipped: Bool
    ) { }

    func tutorialController(
        _ tutorialController: TutorialController,
        shouldLoadConfigurationForCoachMarkAt index: Int
    ) -> Bool {
        true
    }

    func tutorialController(
        _ tutorialController: TutorialController,
        shouldHandleOverlayTapAt index: Int
    ) -> Bool{
        true
    }
}
