// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest
@testable import Instructions

class PassthroughGenericTests: XCTestCase {
    func testHitTestOnRootView() {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 70)
        let rootView = InstructionsRootView(frame: frame)
        let passThroughRootView = InstructionsRootView(frame: frame)

        passThroughRootView.passthrough = true

        XCTAssertEqual(rootView.hitTest(CGPoint(x: 25, y: 25), with: nil), rootView)
        XCTAssertEqual(passThroughRootView.hitTest(CGPoint(x: 25, y: 25), with: nil), nil)

        XCTAssertEqual(rootView.hitTest(CGPoint(x: 150, y: 150), with: nil), nil)
        XCTAssertEqual(passThroughRootView.hitTest(CGPoint(x: 150, y: 150), with: nil), nil)
    }

    func testPassthroughHitTestOnWindow() {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 70)
        let window = InstructionsWindow(frame: frame)
        window.isHidden = false

        XCTAssertEqual(window.hitTest(CGPoint(x: 25, y: 25), with: nil), nil)
        XCTAssertEqual(window.hitTest(CGPoint(x: 150, y: 150), with: nil), nil)
    }

    func testPassthroughHitTestOnPassthroughView() {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 70)
        let view = PassthroughView(frame: frame)

        XCTAssertEqual(view.hitTest(CGPoint(x: 25, y: 25), with: nil), nil)
        XCTAssertEqual(view.hitTest(CGPoint(x: 150, y: 150), with: nil), nil)
    }
}
