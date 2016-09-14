// CustomCoachMarkArrowView.swift
//
// Copyright (c) 2015, 2016 Frédéric Maquin <fred@ephread.com>
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
import Instructions

// Custom coach mark body (with the secret-like arrow)
internal class CustomCoachMarkArrowView : UIView, CoachMarkArrowView {
    //mark: - Internal properties
    var topPlateImage = UIImage(named: "coach-mark-top-plate")
    var bottomPlateImage = UIImage(named: "coach-mark-bottom-plate")
    var plate = UIImageView()

    var highlighted: Bool = false

    //mark: - Private properties
    fileprivate var column = UIView()

    //mark: - Initialization
    init?(orientation: CoachMarkArrowOrientation) {
        super.init(frame: CGRect.zero)

        if orientation == .top {
            self.plate.image = topPlateImage
        } else {
            self.plate.image = bottomPlateImage
        }

        self.translatesAutoresizingMaskIntoConstraints = false
        self.column.translatesAutoresizingMaskIntoConstraints = false
        self.plate.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(plate)
        self.addSubview(column)

        plate.backgroundColor = UIColor.clear
        column.backgroundColor = UIColor.white

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[plate]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["plate" : plate]))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[column(==3)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["column" : column]))

        self.addConstraint(NSLayoutConstraint(item: column, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))

        if orientation == .top {
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[plate(==5)][column(==10)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["plate" : plate, "column" : column]))
        } else {
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[column(==10)][plate(==5)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["plate" : plate, "column" : column]))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }
}
