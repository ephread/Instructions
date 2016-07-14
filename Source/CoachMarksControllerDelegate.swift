// CoachMarksControllerDelegate.swift
//
// Copyright (c) 2015 Frédéric Maquin <fred@ephread.com>
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

/// Give a chance to react when coach marks are displayed
public protocol CoachMarksControllerDelegate: class {
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkWillLoadForIndex index: Int) -> Bool

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkWillShow coachMark: inout CoachMark, forIndex index: Int)

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkWillDisappear coachMark: CoachMark, forIndex index: Int)
    
    func didFinishShowingFromCoachMarksController(_ coachMarksController: CoachMarksController)
}

public extension CoachMarksControllerDelegate {
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkWillLoadForIndex index: Int) -> Bool {
        return true;
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkWillShow coachMark: inout CoachMark, forIndex index: Int) { }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkWillDisappear coachMark: CoachMark, forIndex index: Int) {}

    func didFinishShowingFromCoachMarksController(_ coachMarksController: CoachMarksController) {}
}
