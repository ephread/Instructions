// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

class MaskView: UIView {

    override public class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    var shapeLayer: CAShapeLayer {
        //swiftlint:disable force_cast
        return layer as! CAShapeLayer
        //swiftlint:enable force_cast
    }

}
