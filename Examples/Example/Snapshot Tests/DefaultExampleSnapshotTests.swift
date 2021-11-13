// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

#if targetEnvironment(macCatalyst)
#else

import DeviceKit
import iOSSnapshotTestCase
import Darwin

class DefaultExampleSnapshotTests: FBSnapshotTestCase {
    var snapshotIndex: Int = 0

    override func setUp() {
        super.setUp()

        snapshotIndex = 0

        fileNameOptions = [.screenScale]
        recordMode = ProcessInfo.processInfo.environment["RECORD_MODE"] != nil

        XCUIApplication().launchWithoutStatusBar()
        XCUIDevice.shared.orientation = .portrait
    }

    override func tearDown() {
        super.tearDown()
        XCUIDevice.shared.orientation = .portrait
        snapshotIndex = 0
    }

    func testFlowInIndependentWindow() {
        performSnapshotTest(in: .independentWindow)
    }

    func testRotationInIndependentWindow() {
        performSnapshotTest(in: .independentWindow, rotating: true)
    }

    func testFlowInWindow() {
        performSnapshotTest(in: .sameWindow)
    }

    func testRotationInWindow() {
        performSnapshotTest(in: .sameWindow, rotating: true)
    }

    func testFlowInController() {
        performSnapshotTest(in: .controller)
    }

    func testRotationInController() {
        performSnapshotTest(in: .controller, rotating: true)
    }

    func performSnapshotTest(
        in context: Context,
        rotating: Bool = false
    ) {
        let app = XCUIApplication()

        switch context {
        case .independentWindow:
            let cell = app.tables.staticTexts["Independent Window"]
            cell.tap()
        case .sameWindow:
            let cell = app.tables.staticTexts["Controller Window"]
            cell.tap()
        case .controller:
            let cell = app.tables.staticTexts["Controller"]
            cell.tap()
        }

        let body = app.otherElements["AccessibilityIdentifiers.coachMarkBody"]

        for _ in 0..<5 {
            if body.waitForExistence(timeout: 5) {
                snapshot(app, presentationContext: context)
                body.tap()
                if rotating {
                    let currentOrientation = XCUIDevice.shared.orientation
                    if currentOrientation == .portrait {
                        XCUIDevice.shared.orientation = .landscapeLeft
                    } else if currentOrientation == .landscapeLeft {
                        XCUIDevice.shared.orientation = .portrait
                    }
                }
            }
        }
    }

    func snapshot(_ app: XCUIApplication, presentationContext: Context) {
        // When animations are involved, even when disabled, snapshotting through
        // UI Testing is remarkably brittle -> sleeping for additional stability
        // when snapshotting.
        //
        // TODO: Figure out a way to use Point-Free's library while mimicking
        // proper behaviour.
        Thread.sleep(forTimeInterval: 0.1)

        let orientation = XCUIDevice.shared.orientation
        let image = app.screenshot().image
        let imageView = UIImageView(image: image.cropped(using: orientation))

        let identifier = """
                         \(presentationContext.name)_\(snapshotIndex)_\
                         \(orientation.name)_\(Device.current.snapshotDescription)
                         """

        FBSnapshotVerifyView(
            imageView,
            identifier: identifier,
            perPixelTolerance: 0.1,
            overallTolerance: 0.002
        )

        snapshotIndex += 1
    }
}

enum Context: String {
    case independentWindow, sameWindow, controller

    var name: String { rawValue }
}

extension UIDeviceOrientation {
    var name: String {
        switch self {
        case .unknown: return "unknown"
        case .portrait: return "portrait"
        case .portraitUpsideDown: return "portraitUpsideDown"
        case .landscapeLeft: return "landscapeLeft"
        case .landscapeRight: return "landscapeRight"
        case .faceUp: return "faceUp"
        case .faceDown: return "faceDown"
        @unknown default: return "unknown"
        }
    }
}
#endif
