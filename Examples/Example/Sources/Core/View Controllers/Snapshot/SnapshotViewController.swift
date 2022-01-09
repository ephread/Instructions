// Copyright (c)  2021-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

internal class SnapshotViewController: DefaultViewController {

    weak var snapshotDelegate: TutorialControllerDelegate?

    // MARK: Protocol Conformance | TutorialDelegate
    func tutorialController(
        _ tutorialController: TutorialController,
        willShowCoachMarkWith configuration: inout CoachMarkConfiguration,
        after configurationChange: ConfigurationChange?,
        at index: Int
    ) {
        snapshotDelegate?.tutorialController(
            tutorialController,
            willShowCoachMarkWith: &configuration,
            after: configurationChange,
            at: index
        )
    }

    func tutorialController(
        _ tutorialController: TutorialController,
        didShowCoachMarkWith configuration: ComputedCoachMarkConfiguration,
        after configurationChange: ConfigurationChange?,
        at index: Int
    ) {
        snapshotDelegate?.tutorialController(
            tutorialController,
            didShowCoachMarkWith: configuration,
            after: configurationChange,
            at: index
        )
    }

    func tutorialController(
        _ tutorialController: TutorialController,
        willHideCoachMarkWith configuration: ComputedCoachMarkConfiguration,
        at index: Int
    ) {
        snapshotDelegate?.tutorialController(
            tutorialController,
            willHideCoachMarkWith: configuration,
            at: index
        )
    }

    func tutorialController(
        _ tutorialController: TutorialController,
        didHideCoachMarkWith configuration: ComputedCoachMarkConfiguration,
        at index: Int
    ) {
        snapshotDelegate?.tutorialController(
            tutorialController,
            didHideCoachMarkWith: configuration,
            at: index
        )
    }

    func tutorialController(
        _ tutorialController: TutorialController,
        didEndTutorialBySkipping skipped: Bool
    ) {
        snapshotDelegate?.tutorialController(
            tutorialController,
            didEndTutorialBySkipping: skipped
        )
    }

    override func tutorialController(
        _ tutorialController: TutorialController,
        shouldLoadConfigurationForCoachMarkAt index: Int
    ) -> Bool {
        snapshotDelegate?.tutorialController(
            tutorialController,
            shouldLoadConfigurationForCoachMarkAt: index
        ) ?? true
    }

    func tutorialController(
        _ tutorialController: TutorialController,
        shouldHandleOverlayTapAt index: Int
    ) -> Bool {
        snapshotDelegate?.tutorialController(
            tutorialController,
            shouldHandleOverlayTapAt: index
        ) ?? true
    }
}
