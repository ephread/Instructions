// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

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
