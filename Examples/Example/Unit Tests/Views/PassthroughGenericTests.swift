// PassthroughGenericTests.swift
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

class PassthroughGenericTests: XCTestCase {
    func testHitTestOnRootView() {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 70)
        let rootView = InstructionsRootView(frame: frame)
        let passThroughrootView = InstructionsRootView(frame: frame)

        passThroughrootView.passthrough = true

        XCTAssertEqual(rootView.hitTest(CGPoint(x: 25, y: 25), with: nil), rootView)
        XCTAssertEqual(passThroughrootView.hitTest(CGPoint(x: 25, y: 25), with: nil), nil)

        XCTAssertEqual(rootView.hitTest(CGPoint(x: 150, y: 150), with: nil), nil)
        XCTAssertEqual(passThroughrootView.hitTest(CGPoint(x: 150, y: 150), with: nil), nil)
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
