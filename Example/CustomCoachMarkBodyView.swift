// CustomCoachMarkBodyView.swift
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
import Instructions

// Custom coach mark body (with the secret-like arrow)
internal class CustomCoachMarkBodyView : UIView, CoachMarkBodyView {
    //MARK: - Internal properties
    var nextControl: UIControl? {
        get {
            return self.nextButton
        }
    }

    var highlighted: Bool = false

    var nextButton = UIButton()
    var hintLabel = UITextView()

    weak var highlightArrowDelegate: CoachMarkBodyHighlightArrowDelegate? = nil

    // MARK: - Initialization
    override init (frame: CGRect) {
        super.init(frame: frame)

        self.setupInnerViewHierarchy()
    }

    convenience init() {
        self.init(frame: CGRectZero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }

    //MARK: - Private methods
    private func setupInnerViewHierarchy() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.whiteColor()

        self.clipsToBounds = true
        self.layer.cornerRadius = 4

        self.hintLabel.backgroundColor = UIColor.clearColor()
        self.hintLabel.textColor = UIColor.darkGrayColor()
        self.hintLabel.font = UIFont.systemFontOfSize(15.0)
        self.hintLabel.scrollEnabled = false
        self.hintLabel.textAlignment = .Justified
        self.hintLabel.layoutManager.hyphenationFactor = 1.0
        self.hintLabel.editable = false

        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.hintLabel.translatesAutoresizingMaskIntoConstraints = false

        self.nextButton.userInteractionEnabled = true
        self.hintLabel.userInteractionEnabled = false

        self.nextButton.setBackgroundImage(UIImage(named: "button-background"), forState: .Normal)
        self.nextButton.setBackgroundImage(UIImage(named: "button-background-highlighted"), forState: .Highlighted)

        self.nextButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.nextButton.titleLabel?.font = UIFont.systemFontOfSize(15.0)

        self.addSubview(nextButton)
        self.addSubview(hintLabel)

        self.addConstraint(NSLayoutConstraint(item: nextButton, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[nextButton(==30)]", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["nextButton": nextButton]))

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(5)-[hintLabel]-(5)-|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["hintLabel": hintLabel]))

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(10)-[hintLabel]-(10)-[nextButton(==40)]-(10)-|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["hintLabel": hintLabel, "nextButton": nextButton]))
    }
}