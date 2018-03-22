// OverlayView.swift
//
// Copyright (c) 2015 - 2017 Frédéric Maquin <fred@ephread.com>
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

import UIKit

// Overlay a blocking view on top of the screen and handle the cutout path
// around the point of interest.
class OverlayView: UIView {
    internal static let sublayerName = "Instructions.OverlaySublayer"

    var cutoutPath: UIBezierPath?

    /// Used to temporarily enable touch forwarding isnide the cutoutPath.
    public var allowTouchInsideCutoutPath: Bool = false

    // MARK: - Initialization
    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    // MARK: - Internal methods
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)

        if hitView == self {
            guard let cutoutPath = self.cutoutPath else {
                return hitView
            }

            if !self.allowTouchInsideCutoutPath {
                return hitView
            }

            if cutoutPath.contains(point) {
                return nil
            } else {
                return hitView
            }
        }

        return hitView
    }
}
