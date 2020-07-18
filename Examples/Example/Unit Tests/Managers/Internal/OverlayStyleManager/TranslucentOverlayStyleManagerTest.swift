// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest
@testable import Instructions

class TranslucentOverlayStyleManagerTest: XCTestCase {

    private let overlayView = OverlayView()
    private let translucentStyleManager = TranslucentOverlayStyleManager(color: UIColor.gray)

    var viewIsVisibleExpectation: XCTestExpectation?

    override func setUp() {
        super.setUp()
        overlayView.frame = CGRect(x: 0, y: 0, width: 365, height: 667)
        overlayView.alpha = 0.0

        translucentStyleManager.overlayView = overlayView
    }

    override func tearDown() {
        super.tearDown()
        viewIsVisibleExpectation = nil
    }

    func testThatOverlayIsShown() {
        self.viewIsVisibleExpectation = self.expectation(description: "viewIsVisible")

        translucentStyleManager.showOverlay(true, withDuration: 1.0) { _ in
            XCTAssertEqual(self.overlayView.alpha, 1.0)
            XCTAssertEqual(self.overlayView.isHidden, false)
            XCTAssertEqual(self.overlayView.backgroundColor, UIColor.clear)
            XCTAssertEqual(self.overlayView.holder.layer.sublayers?[0].backgroundColor,
                           UIColor.gray.cgColor)

            self.viewIsVisibleExpectation?.fulfill()
        }

        self.waitForExpectations(timeout: 1.1) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatOverlayIsHidden() {
        viewIsVisibleExpectation = expectation(description: "viewIsVisible")

        translucentStyleManager.showOverlay(false, withDuration: 1.0) { _ in
            XCTAssertEqual(self.overlayView.alpha, 0.0)
            self.viewIsVisibleExpectation?.fulfill()
        }

        self.waitForExpectations(timeout: 1.1) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
