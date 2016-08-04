// CoachMarkArrowDefaultView.swift
//
// Copyright (c) 2015 Frédéric Maquin <fred@ephread.com>
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

/// A concrete implementation of the coach mark arrow view and the
/// default one provided by the library.
public class CoachMarkArrowDefaultView: UIImageView, CoachMarkArrowView {
    //MARK: - Initialization
    public init(orientation: CoachMarkArrowOrientation) {
        let image, highlightedImage: UIImage?

        if orientation == .Top {
            image = UIImage(namedInInstructions: "arrow-top")
            highlightedImage = UIImage(namedInInstructions: "arrow-top-highlighted")
        } else {
            image = UIImage(namedInInstructions: "arrow-bottom")
            highlightedImage = UIImage(namedInInstructions: "arrow-bottom-highlighted")
        }

        super.init(image: image, highlightedImage: highlightedImage)

        self.translatesAutoresizingMaskIntoConstraints = false

        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute,
            multiplier: 1, constant: self.image!.size.width))

        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute,
            multiplier: 1, constant: self.image!.size.height))
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }
}
