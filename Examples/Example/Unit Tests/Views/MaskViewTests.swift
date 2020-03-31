// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest
@testable import Instructions

class MaskViewTests: XCTestCase {
    func testLayerClass() {
        let maskView = MaskView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

        XCTAssertTrue(maskView.layer is CAShapeLayer)
        XCTAssertEqual(maskView.shapeLayer, maskView.layer)
    }
}
