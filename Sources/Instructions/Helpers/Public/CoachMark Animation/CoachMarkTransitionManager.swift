// CoachMarkTransitionManager.swift
//
// Copyright (c) 2018 Frédéric Maquin <fred@ephread.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/// An object provided through the animation delegate methods,
/// so that you can customize the appearance transitions of the given
/// coach mark. You should set animation parameters through the
/// `parameters` property first and then, call `animate`.
public class CoachMarkTransitionManager: CoachMarkAnimationManagement {
    // MARK: Internal properties
    /// Used to descriminate between regular animations and keyframe-based animations.
    internal var animationType: AnimationType = .regular

    /// Block run before the animation block to setup any initial state required
    /// by the animation.
    internal var initialState: (() -> Void)?

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
    /// Use this method to register the animations which will be used to show/hide the
    /// coach mark. A `CoachMarkAnimationManagementContext` will be passed to the
    /// animation block so that you will be able to access the animation parameters
    /// and the related coach mark. Use this object rather than capturing a reference to
    /// `CoachMarkAnimationManager`.
    ///
    /// - Parameters:
    ///   - type: type of the animation
    ///   - animations: animation block
    ///   - fromInitialState: initial state of the animation
    ///   - completion: completion block
    public func animate(_ type: AnimationType,
                        animations: @escaping (CoachMarkAnimationManagementContext) -> Void,
                        fromInitialState initialState: (() -> Void)? = nil,
                        completion: ((Bool) -> Void)? = nil) {
        self.initialState = initialState
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
