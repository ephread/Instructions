// CoachMarksController+Proxy.swift
//
// Copyright (c) 2016 Frédéric Maquin <fred@ephread.com>
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

extension CoachMarksController: CoachMarksControllerProxyDataSource {
    func numberOfCoachMarks() -> Int {
        return dataSource!.numberOfCoachMarksForCoachMarksController(self)
    }

    func coachMarkForIndex(index: Int) -> CoachMark {
        return dataSource!.coachMarksController(self, coachMarkForIndex: index)
    }

    func coachMarkViewsForIndex(index: Int, coachMark: CoachMark)
        -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
            return dataSource!.coachMarksController(self,
                                                    coachMarkViewsForIndex: index,
                                                    coachMark: coachMark)
    }

    func constraintsForSkipView(skipView: UIView,
                                inParentView parentView: UIView)
        -> [NSLayoutConstraint]? {
            return dataSource?.coachMarksController(self,
                                                    constraintsForSkipView: skipView,
                                                    inParentView: parentView)
    }
}

extension CoachMarksController: CoachMarksControllerProxyDelegate {
    func coachMarkWillLoadForIndex(index: Int) -> Bool {
        guard let delegate = delegate else { return true }

        return delegate.coachMarksController(self, coachMarkWillLoadForIndex: index)
    }

    func coachMarkWillShow(inout coachMark: CoachMark, forIndex index: Int) {
        delegate?.coachMarksController(self,
                                       coachMarkWillShow: &coachMark,
                                       forIndex: index)
    }

    func coachMarkWillDisappear(coachMark: CoachMark, forIndex index: Int) {
        delegate?.coachMarksController(self,
                                       coachMarkWillDisappear: coachMark,
                                       forIndex: index)
    }

    func didFinishShowingAndWasSkipped(skipped: Bool) {
        delegate?.coachMarksController(self, didFinishShowingAndWasSkipped: skipped)
    }
}
