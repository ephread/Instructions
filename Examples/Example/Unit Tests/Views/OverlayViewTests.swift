// OverlayViewTests.swift
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

import XCTest
@testable import Instructions

class OverlayViewTests: XCTestCase {
    func testCutoutPathHitTestTest() {
        let overlayView = OverlayView()
        overlayView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        XCTAssertEqual(overlayView.hitTest(CGPoint(x: 25, y: 25), with: nil), overlayView)
        XCTAssertEqual(overlayView.hitTest(CGPoint(x: 90, y: 90), with: nil), overlayView)

        overlayView.cutoutPath = UIBezierPath(rect: CGRect(x: 20, y: 20, width: 30, height: 30))

        XCTAssertEqual(overlayView.hitTest(CGPoint(x: 25, y: 25), with: nil), overlayView)
        XCTAssertEqual(overlayView.hitTest(CGPoint(x: 90, y: 90), with: nil), overlayView)

        overlayView.allowTouchInsideCutoutPath = true

        XCTAssertEqual(overlayView.hitTest(CGPoint(x: 25, y: 25), with: nil), nil)
        XCTAssertEqual(overlayView.hitTest(CGPoint(x: 90, y: 90), with: nil), overlayView)
        XCTAssertEqual(overlayView.hitTest(CGPoint(x: 150, y: 150), with: nil), nil)
    }
}
