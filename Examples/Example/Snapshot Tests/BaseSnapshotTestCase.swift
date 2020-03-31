// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import Foundation

@testable import Instructions
@testable import InstructionsExample
import FBSnapshotTestCase

class BaseSnapshotTests: FBSnapshotTestCase {
    var window: UIWindow!

    override func setUp() {
        super.setUp()

        window = UIWindow()
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.activeScene {
                window = UIWindow(windowScene: windowScene)
            }
        }

        window.frame = UIScreen.main.bounds
        fileNameOptions  = [.device, .OS, .screenSize, .screenScale]
//        recordMode = true
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
