// CoachMarksControllerDelegate.swift
//
// Copyright (c) 2015, 2016 Frédéric Maquin <fred@ephread.com>
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

/// Give a chance to react when coach marks are displayed
public protocol CoachMarksControllerDelegate: class {
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkWillLoadAt index: Int) -> Bool

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkWillShow coachMark: inout CoachMark,
                              at index: Int)

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkWillDisappear coachMark: CoachMark,
                              at index: Int)

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didFinishShowingAndWasSkipped skipped: Bool)
}

public extension CoachMarksControllerDelegate {
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkWillLoadAt index: Int) -> Bool {
        return true
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkWillShow coachMark: inout CoachMark,
                              at index: Int) { }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkWillDisappear coachMark: CoachMark,
                              at index: Int) { }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didFinishShowingAndWasSkipped skipped: Bool) { }

    // swiftlint:disable line_length
    final func didFinishShowingFromCoachMarksController(_ coachMarksController: CoachMarksController) {
        print("didFinishShowingFromCoachMarksController(_:) has been deprecated " +
              "and won't work anymore, if you implemented this method in your " +
              "delegate, please use coachMarksController(_:didFinishShowingAndWasSkipped:) " +
              "instead. Otherwise, ignore this message, which will be removed with 0.5.0")
    }
}

protocol CoachMarksControllerProxyDelegate: class {
    func coachMarkWillLoad(at index: Int) -> Bool

    func coachMarkWillShow(_ coachMark: inout CoachMark, at index: Int)

    func coachMarkWillDisappear(_ coachMark: CoachMark, at index: Int)

    func didFinishShowingAndWasSkipped(_ skipped: Bool)
}
