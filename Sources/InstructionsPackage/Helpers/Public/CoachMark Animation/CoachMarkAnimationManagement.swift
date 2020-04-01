// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

// MARK: Main protocols
/// Define context in which the transition will execute. Note that here, what "context" means
/// really is "animation parameters" and "coach mark metadata".
public protocol CoachMarkAnimationManagementContext {
    var coachMark: CoachMark { get }
    var parameters: AnimationParameters { get }
}

/// Common ground for coach mark animation managers.
protocol CoachMarkAnimationManagement: CoachMarkAnimationManagementContext {
    var animations: ((CoachMarkAnimationManagementContext) -> Void)? { get }
    var completion: ((Bool) -> Void)? { get }
    var animationType: AnimationType { get }
}

// MARK: Enums
public enum AnimationType {
    case regular, keyframe
}

// MARK: Structs
/// Hold the parameters which will eventually be passed to `UIView.animate`.
public struct AnimationParameters {
    /// The total duration of the animations, measured in seconds.
    /// If you specify a negative value or 0, the changes are made without animating them.
    public var duration: TimeInterval = Constants.coachMarkFadeAnimationDuration

    /// The amount of time (measured in seconds) to wait before beginning the animations.
    /// Specify a value of 0 to begin the animations immediately.
    public var delay: TimeInterval = 0

    /// A mask of options indicating how you want to perform the animations.
    /// For a list of valid constants, see UIView.AnimationOptions.
    /// The value of this property will only be used for regular animations.
    public var options: UIView.AnimationOptions = []

    /// A mask of options indicating how you want to perform the animations.
    /// For a list of valid constants, see UIView.KeyframeAnimationOptions.
    /// The value of this property will only be used for keyframe animations.
    public var keyframeOptions: UIView.KeyframeAnimationOptions = []
}

internal struct CoachMarkAnimationManagerContext: CoachMarkAnimationManagementContext {
    let coachMark: CoachMark
    let parameters: AnimationParameters
}
