// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

#if targetEnvironment(macCatalyst)
#else

import Foundation

@testable import Instructions
@testable import InstructionsExample
import iOSSnapshotTestCase

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
        fileNameOptions  = [.device, .OS, .screenScale]

        recordMode = ProcessInfo.processInfo.environment["RECORD_MODE"] != nil
    }

    override func tearDown() {
        super.tearDown()
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
        window.isHidden = true
        window = nil
    }

    func instructionsWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            let windows = UIApplication.shared.activeScene?.windows

            return windows?.filter {
                $0.accessibilityIdentifier == "AccessibilityIdentifiers.window"
            }.first
        } else {
            return UIApplication.shared.windows.filter {
                $0.accessibilityIdentifier == "AccessibilityIdentifiers.window"
            }.first
        }
    }
}

public extension UIInterfaceOrientation {
    var deviceOrientation: UIDeviceOrientation {
        switch self {
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .unknown:
            return .unknown
        @unknown default:
            return .unknown
        }
    }
}

public extension UIImage {
    var dimensions: String { "\(Int(size.width))x\(Int(size.height))" }
}

#endif
