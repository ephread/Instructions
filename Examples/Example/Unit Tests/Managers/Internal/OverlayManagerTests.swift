// OverlayManagerTests.swift
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

class OverlayManagerTests: XCTestCase {

    var manager: OverlayManager!

    override func setUp() {
        manager = OverlayManager()
    }

    func testThatTapIsRegistered() {
        XCTAssertTrue(manager.overlayView.gestureRecognizers?.isEmpty ?? true)
        manager.allowTap = true
        XCTAssertFalse(manager.overlayView.gestureRecognizers?.isEmpty ?? true)
    }

    func testPropertyTranfer() {
        let cutoutPath = UIBezierPath(rect: CGRect(x: 20, y: 20, width: 30, height: 30))

        manager.allowTouchInsideCutoutPath = true
        manager.cutoutPath = cutoutPath

        XCTAssertTrue(manager.overlayView.allowTouchInsideCutoutPath)
        XCTAssertEqual(manager.overlayView.cutoutPath, cutoutPath)
    }
}
