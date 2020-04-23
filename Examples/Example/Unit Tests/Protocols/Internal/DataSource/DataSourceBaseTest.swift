// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest
@testable import Instructions

class DataSourceBaseTest: XCTestCase {

    var coachMarksController = CoachMarksController()
    var parentController = UIViewController()
    var mockedWindow = UIWindow()

    override func setUp() {
        super.setUp()

        UIView.setAnimationsEnabled(false)
        self.mockedWindow.addSubview(self.parentController.view)
    }
}
