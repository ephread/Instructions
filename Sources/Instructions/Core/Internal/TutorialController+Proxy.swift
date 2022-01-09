// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

extension TutorialController: TutorialControllerDataSourceProxy {
    func numberOfCoachMarks() -> Int {
        guard let dataSource = dataSource else {
            fatalError(ErrorMessage.Fatal.dataSourceNotSet)
        }

        return dataSource.numberOfCoachMarks(in: self)
    }

    func configurationForCoachMark(at index: Int) -> CoachMarkConfiguration {
        guard let dataSource = dataSource else {
            fatalError(ErrorMessage.Fatal.dataSourceNotSet)
        }

        return dataSource.tutorialController(self, configurationForCoachMarkAt: index)
    }

    func compoundViewFor(
        coachMark: ComputedCoachMarkConfiguration,
        at index: Int
    ) -> CoachMarkViewComponents {
        guard let dataSource = dataSource else {
            fatalError(ErrorMessage.Fatal.dataSourceNotSet)
        }

        return dataSource.tutorialController(self, compoundViewFor: coachMark, at: index)
    }
}

extension TutorialController: TutorialControllerDelegateProxy {
    func willShowCoachMark(
        with configuration: inout CoachMarkConfiguration,
        after configurationChange: ConfigurationChange?,
        at index: Int
    ) {
        delegate?.tutorialController(
            self,
            willShowCoachMarkWith: &configuration,
            after: configurationChange,
            at: index
        )
    }

    func didShowCoachMark(
        with configuration: ComputedCoachMarkConfiguration,
        after configurationChange: ConfigurationChange?,
        at index: Int
    ) {
        delegate?.tutorialController(
            self,
            didShowCoachMarkWith: configuration,
            after: configurationChange,
            at: index
        )
    }

    func willHideCoachMark(with configuration: ComputedCoachMarkConfiguration, at index: Int) {
        delegate?.tutorialController(self, willHideCoachMarkWith: configuration, at: index)
    }

    func didHideCoachMark(with configuration: ComputedCoachMarkConfiguration, at index: Int) {
        delegate?.tutorialController(self, didHideCoachMarkWith: configuration, at: index)
    }

    func didEndTutorial(bySkipping skipped: Bool) {
        delegate?.tutorialController(self, didEndTutorialBySkipping: skipped)
    }

    func shouldLoadConfigurationForCoachMark(at index: Int) -> Bool {
        delegate?.tutorialController(self, shouldLoadConfigurationForCoachMarkAt: index) ?? true
    }

    func shouldHandleOverlayTap(at index: Int) -> Bool  {
        delegate?.tutorialController(self, shouldHandleOverlayTapAt: index) ?? true
    }
}

extension TutorialController: TutorialControllerDelegateAnimationProxy {
    func willDisplay(
        coachMark: UIView,
        at index: Int,
        transitioner: CoachMarkTransitionManager
    ) {
        guard let delegate = delegate as? TutorialControllerDelegateAnimation else { return }

        delegate.tutorialController(
            self,
            willDisplayCoachMark: coachMark,
            at: index,
            transitioner: transitioner
        )
    }

    func willEndDisplaying(
        coachMark: UIView,
        at index: Int,
        transitioner: CoachMarkTransitionManager
    ) {
        guard let delegate = delegate as? TutorialControllerDelegateAnimation else { return }

        delegate.tutorialController(
            self,
            willEndDisplayingCoachMark: coachMark,
            at: index,
            transitioner: transitioner
        )
    }

    func animate(
        coachMark: UIView,
        at index: Int,
        animator: CoachMarkAnimationManager
    ) {
        guard let delegate = delegate as? TutorialControllerDelegateAnimation else { return }

        delegate.tutorialController(
            self,
            animateCoachMark: coachMark,
            at: index,
            animator: animator
        )
    }
}
