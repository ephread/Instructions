// OverlayStyleManager.swift
//
// Copyright (c) 2017 Frédéric Maquin <fred@ephread.com>
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

import UIKit

/// This protocol expected to be implemented by the CoachMarkController.
/// A snapshottable object will return a snapshot view of its content.
/// Useful when dealing with multiple windows.
protocol Snapshottable: class {
    /// Returns: A snapshot of the view hierarchy.
    func snapshot() -> UIView?
}

/// Define a common API for different types of overlay.
/// (Blurring the content behind, simple background color, etc.)
/// Takes care of displaying and animating the overlay / cutout path (doesn't
/// deals with the coach mark view itself).
protocol OverlayStyleManager: class {
    /// The overlay managed by the styleManager.
    var overlayView: OverlayView? { get set }

    /// Called when the size of usable screen space will change.
    func viewWillTransition()

    /// Called when the size of usable screen space did change.
    func viewDidTransition()

    /// Show/hide the overlay.
    ///
    /// - Parameters:
    ///   - show: `true` to show the overlay, `false` to hide.
    ///   - duration: duration of the animation
    ///   - completion: a block to execute after compleion.
    func showOverlay(_ show: Bool, withDuration duration: TimeInterval,
                     completion: ((Bool) -> Void)?)

    /// Show/hide the cutout.
    ///
    /// - Parameters:
    ///   - show: `true` to show the overlay, `false` to hide.
    ///   - duration: duration of the animation
    ///   - completion: a block to execute after compleion.
    func showCutout(_ show: Bool, withDuration duration: TimeInterval,
                    completion: ((Bool) -> Void)?)
}
