// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import Foundation

/// An object provided through the animation delegate methods,
/// so that you can customize the idle animation of the given
/// coach mark. You should set animation parameters through the
/// `parameters` property first and then, call `animate`.
public class CoachMarkAnimationManager: CoachMarkAnimationManagement {
    // MARK: Internal properties
    /// Used to descriminate between regular animations and keyframe-based animations.
    internal var animationType: AnimationType = .regular

    /// Animation block
    internal var animations: ((CoachMarkAnimationManagementContext) -> Void)?

    /// Completion block
    internal var completion: ((Bool) -> Void)?

    // MARK: Public properties
    public let coachMark: CoachMark
    public var parameters = AnimationParameters()

    // MARK: Lifecycle
    init(coachMark: CoachMark) {
        self.coachMark = coachMark
    }

    // MARK: Public methods
    /// Use this method to register the animations which will be used while coach marks will be
    /// displayed. A `CoachMarkAnimationManagementContext` will be passed to the animation block
    /// so that you will be able to access the animation parameters and the related coach mark.
    /// Use this object rather than capturing a reference to `CoachMarkAnimationManager`.
    ///
    /// - Parameters:
    ///   - type: type of the animation
    ///   - animations: animation block
    ///   - completion: completion block
    public func animate(_ type: AnimationType,
                        animations: @escaping (CoachMarkAnimationManagementContext) -> Void,
                        completion: ((Bool) -> Void)? = nil) {
        self.animations = animations
        self.completion = completion

        animationType = type
    }

    // MARK: Internal methods
    /// Create the context from the current parameters and coach mark.
    ///
    /// - Returns: new context object.
    internal func createContext() -> CoachMarkAnimationManagementContext {
        return CoachMarkAnimationManagerContext(coachMark: coachMark,
                                                parameters: parameters)
    }
}
