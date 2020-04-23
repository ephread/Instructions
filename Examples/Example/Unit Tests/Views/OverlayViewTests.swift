// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

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
