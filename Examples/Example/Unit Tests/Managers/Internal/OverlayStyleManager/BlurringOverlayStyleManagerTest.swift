// Copyright (c) 2017-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest
@testable import Instructions

class BlurringOverlayStyleManagerTest: XCTestCase {

    private let overlayView = OverlayView()
    private let blurringStyleManager = BlurringOverlayStyleManager(style: .extraLight)
    private let snapshotDelegate = SnapshotDelegate() // swiftlint:disable:this weak_delegate

    var viewIsVisibleExpectation: XCTestExpectation?

    override func setUp() {
        super.setUp()
        overlayView.frame = CGRect(x: 0, y: 0, width: 365, height: 667)
        overlayView.alpha = 0.0

        blurringStyleManager.overlayView = overlayView
        blurringStyleManager.snapshotDelegate = snapshotDelegate
    }

    override func tearDown() {
        super.tearDown()
        viewIsVisibleExpectation = nil
    }

    func testThatOverlayIsShown() {
        self.viewIsVisibleExpectation = self.expectation(description: "viewIsVisible")

        blurringStyleManager.showOverlay(true, withDuration: 1.0) { _ in
            XCTAssertEqual(self.overlayView.alpha, 1.0)
            XCTAssertEqual(self.overlayView.isHidden, false)

            let containsBlur = self.overlayView.holder.subviews
                                               .filter { $0 is UIVisualEffectView }
                                               .count == 2

            XCTAssertTrue(containsBlur)

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

        blurringStyleManager.showOverlay(false, withDuration: 1.0) { _ in
            XCTAssertEqual(self.overlayView.alpha, 0.0)

            XCTAssertTrue(self.overlayView.holder.subviews.count == 1)

            self.viewIsVisibleExpectation?.fulfill()
        }

        self.waitForExpectations(timeout: 1.1) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

private class SnapshotDelegate: Snapshottable {
    func snapshot() -> UIView? {
        return UIView()
    }
}
