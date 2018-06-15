// OverlaySnapshotViewTests.swift
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

class OverlaySnapshotViewTests: XCTestCase {
    func testHitTest() {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 70)
        let overlayView = OverlaySnapshotView(frame: frame)

        XCTAssertEqual(overlayView.hitTest(CGPoint(x: 25, y: 25), with: nil), nil)
        XCTAssertEqual(overlayView.hitTest(CGPoint(x: 150, y: 150), with: nil), nil)
    }

    func testSubviews() {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 70)
        let overlayView = OverlaySnapshotView(frame: frame)
        let overlayBackgroundView = UIView(frame: frame)
        let overlayVisualEffectView = UIVisualEffectView(frame: frame)

        overlayView.backgroundView = overlayBackgroundView
        overlayView.visualEffectView = overlayVisualEffectView

        XCTAssertEqual(overlayView.backgroundView.superview, overlayView)
        XCTAssertEqual(overlayView.visualEffectView.superview, overlayView)

        overlayView.backgroundView = nil
        overlayView.visualEffectView = nil

        XCTAssertEqual(overlayBackgroundView.superview, nil)
        XCTAssertEqual(overlayVisualEffectView.superview, nil)
    }
}
