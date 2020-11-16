// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest
@testable import Instructions

class OverlayManagerTests: XCTestCase {

    var manager: OverlayManager!

    override func setUp() {
        manager = OverlayManager()
    }

    func testThatTapIsRegistered() {
        XCTAssertTrue(manager.overlayView.gestureRecognizers?.isEmpty ?? true)
        manager.isUserInteractionEnabled = true
        XCTAssertFalse(manager.overlayView.gestureRecognizers?.isEmpty ?? true)
    }

    func testPropertyTransfer() {
        let cutoutPath = UIBezierPath(rect: CGRect(x: 20, y: 20, width: 30, height: 30))

        manager.isUserInteractionEnabledInsideCutoutPath = true
        manager.cutoutPath = cutoutPath

        XCTAssertTrue(manager.overlayView.allowTouchInsideCutoutPath)
        XCTAssertEqual(manager.overlayView.cutoutPath, cutoutPath)
    }
}
