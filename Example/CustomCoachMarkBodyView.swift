// CustomCoachMarkBodyView.swift
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
internal class CustomCoachMarkBodyView : UIView, CoachMarkBodyView {
    //mark: - Internal properties
    var nextControl: UIControl? {
        get {
            return self.nextButton
        }
    }

    var highlighted: Bool = false

    var nextButton = UIButton()
    var hintLabel = UITextView()

    weak var highlightArrowDelegate: CoachMarkBodyHighlightArrowDelegate? = nil

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

    //mark: - Private methods
    fileprivate func setupInnerViewHierarchy() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.white

        self.clipsToBounds = true
        self.layer.cornerRadius = 4

        self.hintLabel.backgroundColor = UIColor.clear
        self.hintLabel.textColor = UIColor.darkGray
        self.hintLabel.font = UIFont.systemFont(ofSize: 15.0)
        self.hintLabel.isScrollEnabled = false
        self.hintLabel.textAlignment = .justified
        self.hintLabel.layoutManager.hyphenationFactor = 1.0
        self.hintLabel.isEditable = false

        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.hintLabel.translatesAutoresizingMaskIntoConstraints = false

        self.nextButton.isUserInteractionEnabled = true
        self.hintLabel.isUserInteractionEnabled = false

        self.nextButton.setBackgroundImage(UIImage(named: "button-background"), for: UIControlState())
        self.nextButton.setBackgroundImage(UIImage(named: "button-background-highlighted"), for: .highlighted)

        self.nextButton.setTitleColor(UIColor.white, for: UIControlState())
        self.nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)

        self.addSubview(nextButton)
        self.addSubview(hintLabel)

        self.addConstraint(NSLayoutConstraint(item: nextButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[nextButton(==30)]", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["nextButton": nextButton]))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[hintLabel]-(5)-|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["hintLabel": hintLabel]))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[hintLabel]-(10)-[nextButton(==40)]-(10)-|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["hintLabel": hintLabel, "nextButton": nextButton]))
    }
}
