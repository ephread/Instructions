// Copyright (c)  2020-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest

extension XCUIApplication {
    func launchWithAnimationsDisabled() {
        launchArguments.append("--UITests")
        launch()
    }
}
