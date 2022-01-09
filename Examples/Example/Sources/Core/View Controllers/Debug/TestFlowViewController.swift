// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

// That's the default controller, using every defaults made available by Instructions.
// It can't get any simpler.
class TestFlowViewController: ProfileViewController {
    // MARK: - IBOutlets
    @IBOutlet var tapMeButton: UIButton!

    // MARK: - Private Properties
    private let text1 = "CoachMark 1"
    private let text2 = "CoachMark 2"
    private let text3 = "CoachMark 3"
    private let text4 = "CoachMark 4"

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tutorialController.dataSource = self
        self.tutorialController.delegate = self

        self.emailLabel?.layer.cornerRadius = 4.0
        self.postsLabel?.layer.cornerRadius = 4.0
        self.reputationLabel?.layer.cornerRadius = 4.0

        let skipView = DefaultCoachMarkSkipperView()
        skipView.setTitle("Skip", for: .normal)

        self.tutorialController.skipper.view = skipView
        self.tutorialController.overlay.isUserInteractionEnabled = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Actions
    @IBAction func performButtonTap(_ sender: AnyObject) {
        self.tutorialController.stop(immediately: true)
        self.tutorialController.start(in: .newWindow(over: self))
    }
}

// MARK: - Protocol Conformance | CoachMarksControllerDelegate
extension TestFlowViewController: TutorialControllerDelegate {
    // MARK: - Protocol Conformance | CoachMarksControllerDelegate
    func tutorialController(
        _ tutorialController: TutorialController,
        shouldLoadConfigurationForCoachMarkAt index: Int
    ) -> Bool {
        print("Should load configuration for coach mark at \(index).")
        return true
    }

    func tutorialController(
        _ tutorialController: TutorialController,
        willShowCoachMarkWith configuration: inout CoachMarkConfiguration,
        after configurationChange: ConfigurationChange?,
        at index: Int
    ) {
        print("Will show coach mark number \(index), after \(configurationChange).")
    }

    func tutorialController(
        _ tutorialController: TutorialController,
        didShowCoachMarkWith configuration: ComputedCoachMarkConfiguration,
        after configurationChange: ConfigurationChange?,
        at index: Int
    ) {
        print("Did show coach mark number \(index), after \(configurationChange).")
    }

    func tutorialController(
        _ tutorialController: TutorialController,
        willHideCoachMarkWith configuration: ComputedCoachMarkConfiguration,
        at index: Int
    ) {
        print("Will hide coach mark number \(index).")
    }

    func tutorialController(
        _ tutorialController: TutorialController,
        didHideCoachMarkWith configuration: ComputedCoachMarkConfiguration,
        at index: Int
    ) {
        print("Did hide coach mark number \(index).")
    }

    func tutorialController(
        _ tutorialController: TutorialController,
        didEndTutorialBySkipping skipped: Bool
    ) {
        print("Did end tutorial (skipped: \(skipped)).")
    }

    func tutorialController(
        _ tutorialController: TutorialController,
        shouldHandleOverlayTapAt index: Int
    ) -> Bool {
        print("Should handle overlay tap when displaying coach mark number \(index).")

        if index >= 2 {
            print("Index greater than or equal to 2, skipping.")
            tutorialController.stop()
            return false
        } else {
            return true
        }
    }
}

// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension TestFlowViewController: TutorialControllerDataSource {

    func numberOfCoachMarks(in tutorialController: TutorialController) -> Int {
        print("Number of coach marks: 4.")
        return 4
    }

    func tutorialController(
        _ tutorialController: TutorialController,
        configurationForCoachMarkAt index: Int
    ) -> CoachMarkConfiguration {
        print("Configuration for coach mark number \(index).")
        switch index {
        case 0:
            return tutorialController.helper.makeCoachMark(
                for: self.navigationController?.navigationBar,
                   cutoutPathMaker: { (frame: CGRect) -> UIBezierPath in
                       return UIBezierPath(rect: frame)
                   }
            )
        case 1:
            return tutorialController.helper.makeCoachMark(for: self.handleLabel)
        case 2:
            var coachMark = tutorialController.helper.makeCoachMark(for: self.tapMeButton)
            coachMark.interaction.isUserInteractionEnabledInsideCutoutPath = true

            return coachMark
        case 3:
            return tutorialController.helper.makeCoachMark(for: self.reputationLabel)
        default:
            return tutorialController.helper.makeCoachMark()
        }
    }

    func tutorialController(
        _ tutorialController: TutorialController,
        compoundViewFor configuration: ComputedCoachMarkConfiguration,
        at index: Int
    ) -> CoachMarkViewComponents {
        print("Compound views number \(index).")
        let views = tutorialController.helper.makeDefaultViews(
            showNextLabel: false,
            showPointer: true,
            position: configuration.position
        )

        switch index {
        case 0:
            views.contentView.hintLabel.text = self.text1
            views.contentView.nextLabel.text = self.nextButtonText
        case 1:
            views.contentView.hintLabel.text = self.text2
            views.contentView.nextLabel.text = self.nextButtonText
        case 2:
            views.contentView.hintLabel.text = self.text3
            views.contentView.nextLabel.text = self.nextButtonText
        case 3:
            views.contentView.hintLabel.text = self.text4
            views.contentView.nextLabel.text = self.nextButtonText
        default: break
        }

        return views
    }
}
