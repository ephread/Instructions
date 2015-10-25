// CoachMarkBodyDefaultView.swift
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

/// A concrete implementation of the coach mark body view and the
/// default one provided by the library.
public class CoachMarkBodyDefaultView : UIControl, CoachMarkBodyView {
    //MARK: - Public properties
    public var nextControl: UIControl? {
        get {
            return self
        }
    }

    public weak var highlightArrowDelegate: CoachMarkBodyHighlightArrowDelegate?

    override public var highlighted: Bool {
        didSet {
            if (self.highlighted) {
                self.backgroundImageView.image = highlightedBackgroundImage
            } else {
                self.backgroundImageView.image = backgroundImage
            }

            self.highlightArrowDelegate?.highlightArrow(self.highlighted)
        }
    }

    public var nextLabel = UILabel()
    public var hintLabel = UITextView()
    public var separator = UIView()

    //MARK: - Private properties
    private let backgroundImage = UIImage(named: "background", inBundle: NSBundle(forClass: CoachMarkBodyDefaultView.self), compatibleWithTraitCollection: nil)

    private let highlightedBackgroundImage = UIImage(named: "background-highlighted", inBundle: NSBundle(forClass: CoachMarkBodyDefaultView.self), compatibleWithTraitCollection: nil)

    private let backgroundImageView: UIImageView

    //MARK: - Initialization
    override public init (frame: CGRect) {
        self.backgroundImageView = UIImageView(image: self.backgroundImage)

        super.init(frame: frame)

        self.setupInnerViewHierarchy()
    }

    convenience public init() {
        self.init(frame: CGRectZero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }

    //MARK: - Private properties
    private func setupInnerViewHierarchy() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundImageView.userInteractionEnabled = false

        self.addSubview(self.backgroundImageView)

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[backgroundImageView]|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["backgroundImageView": self.backgroundImageView]))

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[backgroundImageView]|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["backgroundImageView": self.backgroundImageView]))


        hintLabel.backgroundColor = UIColor.clearColor()
        hintLabel.textColor = UIColor.darkGrayColor()
        hintLabel.font = UIFont.systemFontOfSize(15.0)
        hintLabel.scrollEnabled = false
        hintLabel.textAlignment = .Justified
        hintLabel.layoutManager.hyphenationFactor = 2.0
        hintLabel.editable = false

        nextLabel.textColor = UIColor.darkGrayColor()
        nextLabel.font = UIFont.systemFontOfSize(17.0)
        nextLabel.textAlignment = .Center

        separator.backgroundColor = UIColor.grayColor()

        nextLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false

        nextLabel.userInteractionEnabled = false
        hintLabel.userInteractionEnabled = false
        separator.userInteractionEnabled = false

        self.addSubview(nextLabel)
        self.addSubview(hintLabel)
        self.addSubview(separator)

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[nextLabel]|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["nextLabel": nextLabel]))

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(5)-[hintLabel]-(5)-|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["hintLabel": hintLabel]))

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(15)-[separator]-(15)-|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["separator": separator]))

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(10)-[hintLabel]-(10)-[separator(==1)][nextLabel(==55)]|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["hintLabel": hintLabel, "separator": separator, "nextLabel": nextLabel]))
    }
}
