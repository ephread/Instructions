// TransparentCoachMarkBodyView.swift
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

// Transparent coach mark (text without background, cool arrow)
internal class TransparentCoachMarkBodyView : UIControl, CoachMarkBodyView {
    // mark: - Internal properties
    var nextControl: UIControl? {
        get {
            return self
        }
    }

    weak var highlightArrowDelegate: CoachMarkBodyHighlightArrowDelegate? = nil

    var hintLabel = UITextView()

    // mark: - Initialization
    override init (frame: CGRect) {
        super.init(frame: frame)

        self.setupInnerViewHierarchy()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }

    // mark: - Private methods
    fileprivate func setupInnerViewHierarchy() {
        self.translatesAutoresizingMaskIntoConstraints = false

        hintLabel.backgroundColor = UIColor.clear
        hintLabel.textColor = UIColor.white
        hintLabel.font = UIFont.systemFont(ofSize: 15.0)
        hintLabel.isScrollEnabled = false
        hintLabel.textAlignment = .justified
        hintLabel.layoutManager.hyphenationFactor = 1.0
        hintLabel.isEditable = false

        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.isUserInteractionEnabled = false

        self.addSubview(hintLabel)

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[hintLabel]|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["hintLabel": hintLabel]))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[hintLabel]|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["hintLabel": hintLabel]))
    }
}
