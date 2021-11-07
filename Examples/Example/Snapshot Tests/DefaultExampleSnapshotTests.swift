// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

#if targetEnvironment(macCatalyst)
#else

import iOSSnapshotTestCase

class DefaultExampleSnapshotTests: BaseSnapshotTests {

    var snapshotIndex: Int = 0

    override func setUp() {
        super.setUp()

        snapshotIndex = 0
        XCUIApplication().launch()

        #if targetEnvironment(macCatalyst)
        #else
        XCUIDevice.shared.orientation = .portrait
        #endif

        fileNameOptions = [.device, .OS, .screenScale]

        XCUIDevice.shared.orientation = .portrait
    }

    override func tearDown() {
        super.tearDown()
        XCUIDevice.shared.orientation = .portrait
        snapshotIndex = 0
    }

    func testFlowInIndependentWindow() {
        performSnapshotTest(orientation: .portrait, presentationContext: .independentWindow)
    }

    func testRotationInIndependentWindow() {
        performSnapshotTest(orientation: .landscapeLeft, presentationContext: .independentWindow)
    }

    func testFlowInWindow() {
        performSnapshotTest(orientation: .portrait, presentationContext: .sameWindow)
    }

    func testRotationInWindow() {
        performSnapshotTest(orientation: .landscapeRight, presentationContext: .sameWindow)
    }

    func testFlowInController() {
        performSnapshotTest(orientation: .portrait, presentationContext: .controller)
    }

    func testRotationInController() {
        performSnapshotTest(orientation: .landscapeLeft, presentationContext: .controller)
    }

    func performSnapshotTest(
        orientation: UIDeviceOrientation,
        presentationContext: Context
    ) {
        XCUIDevice.shared.orientation = orientation

        let app = XCUIApplication()

        switch presentationContext {
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
                snapshot(app, presentationContext: presentationContext)
                body.tap()
            }
        }
    }

    func snapshot(_ app: XCUIApplication, presentationContext: Context) {
        let orientation = XCUIDevice.shared.orientation
        let image = app.screenshot().image
        let imageView = UIImageView(image: image)
        let identifier = """
                         \(presentationContext.name)_\(snapshotIndex)_\
                         \(orientation.name)_\(image.dimensions)
                         """
        FBSnapshotVerifyView(
            imageView,
            identifier: identifier,
            perPixelTolerance: 0.05,
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
