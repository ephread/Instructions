// Copyright (c) 2021-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

// TODO: [MIGRATION] Remove
@available(*, unavailable, renamed: "CoachMarkContent")
public typealias CoachMarkBodyView = CoachMarkContent

@available(*, unavailable, renamed: "CoachMarkPointer")
public typealias CoachMarkArrowView = CoachMarkPointer

@available(*, unavailable, renamed: "CoachMarkSkipper")
public typealias CoachMarkSkipView = TutorialSkipper

@available(*, unavailable, renamed: "TutorialControllerDataSource")
public typealias CoachMarkControllerDataSource = TutorialControllerDataSource

@available(*, unavailable, renamed: "TutorialControllerDelegate")
public typealias CoachMarkControllerDelegate = TutorialControllerDelegate

@available(*, unavailable, renamed: "TutorialControllerDelegateAnimation")
public typealias PauseStyle = PauseAction

@available(*, unavailable, renamed: "CoachMarkConfiguration")
public typealias CoachMark = CoachMarkConfiguration

@available(*, unavailable, renamed: "RotationBehavior")
public typealias RotationStyle = RotationBehavior

@available(*, unavailable, renamed: "InterfaceOrientationBehavior")
public typealias InterfaceOrientations = InterfaceOrientationBehavior

@available(*, unavailable, renamed: "DefaultCoachMarkPointerView")
public typealias CoachMarkArrowDefaultView = DefaultCoachMarkPointerView

@available(*, unavailable, renamed: "DefaultCoachMarkContentView")
public typealias CoachMarkBodyDefaultView = DefaultCoachMarkContentView

@available(*, unavailable, renamed: "DefaultCoachMarkSkipperView")
public typealias CoachMarkSkipDefaultView = DefaultCoachMarkSkipperView

@available(*, unavailable, renamed: "CoachMarkContent")
public typealias CoachMarkContentView = CoachMarkContent

public extension TutorialController {
    @available(*, unavailable, message: "Please use 'animator' instead.")
    var animationDelegate: TutorialControllerDelegateAnimation? {
        get { nil }
        set { }
    }

    @available(*, unavailable, renamed: "rotationBehavior")
    var rotationStyle: RotationStyle {
        get { rotationBehavior }
        set { }
    }
}

public extension CoachMarkHelper {
    @available(*, unavailable, renamed: "makeDefaultViews(contentText:nextText:showPointer:position:)")
    func makeDefaultCoachViews(
        withArrow arrow: Bool = true,
        position: ComputedVerticalPosition = .below,
        hintText: String,
        nextText: String? = nil
    ) -> (bodyView: DefaultCoachMarkContentView, arrowView: DefaultCoachMarkPointerView?) {
        fatalError("Please migrate the method call.")
    }

    @available(*, unavailable, renamed: "makeDefaultViews(showNextLabel:showPointer:position:)")
    func makeDefaultCoachViews(
        withArrow arrow: Bool = true,
        withNextText nextText: Bool = true,
        arrowOrientation: ComputedVerticalPosition? = .below
    ) -> (bodyView: DefaultCoachMarkContentView, arrowView: DefaultCoachMarkPointerView?) {
        fatalError("Please migrate the method call.")
    }
}

public extension CoachMarkConfiguration {
    @available(*, unavailable, message: "Set 'position' to '.over' to achieve the same effect.")
    var isDisplayedOverCutoutPath: Bool {
        get { false }
        set { }
    }

    @available(*, unavailable, renamed: "position")
    var arrowOrientation: VerticalPosition {
        get { position }
        set { }
    }

    @available(*, unavailable, renamed: "layout.marginBetweenContentAndPointer")
    var gapBetweenBodyAndArrow: CGFloat {
        get { layout.marginBetweenContentAndPointer }
        set { }
    }

    @available(*, unavailable, renamed: "layout.marginBetweenCoachMarkAndCutoutPath")
    var gapBetweenCoachMarkAndCutoutPath: CGFloat {
        get { layout.marginBetweenCoachMarkAndCutoutPath }
        set { }
    }

    @available(*, unavailable, renamed: "interaction.isUserInteractionEnabledInsideCutoutPath")
    var isUserInteractionEnabledInsideCutoutPath: Bool {
        get { interaction.isUserInteractionEnabledInsideCutoutPath }
        set { }
    }
}

public extension CoachMarkDefaultViewComponents {
    @available(*, unavailable, renamed: "contentView")
    var bodyView: DefaultCoachMarkContentView {
        get { contentView }
        set { }
    }

    @available(*, unavailable, renamed: "pointerView")
    var arrowView: DefaultCoachMarkPointerView? {
        get { pointerView }
        set { }
    }
}
