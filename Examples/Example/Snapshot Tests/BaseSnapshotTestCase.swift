// BaseSnapshotTests.swift
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

import Foundation

@testable import Instructions
@testable import InstructionsExample
import FBSnapshotTestCase

class BaseSnapshotTests: FBSnapshotTestCase {
    var window: UIWindow!

    override func setUp() {
        super.setUp()

        window = UIWindow()
        window.frame = UIScreen.main.bounds
        fileNameOptions  = [.device, .OS, .screenSize, .screenScale]
        //recordMode = true
    }

    override func tearDown() {
        super.tearDown()
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
        window.isHidden = true
        window = nil
    }

    func instructionsWindow() -> UIWindow? {
        let windows = UIApplication.shared.windows

        return windows.filter {
            $0.accessibilityIdentifier == "AccessibilityIdentifiers.window"
            }.first
    }
}
