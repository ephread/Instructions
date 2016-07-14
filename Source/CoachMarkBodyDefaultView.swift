// CoachMarkBodyDefaultView.swift
//
// Copyright (c) 2015 Frédéric Maquin <fred@ephread.com>
//                    Esteban Soto <esteban.soto.dev@gmail.com>
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

    override public var isHighlighted: Bool {
        didSet {
            if (self.isHighlighted) {
                self.backgroundImageView.image = highlightedBackgroundImage
            } else {
                self.backgroundImageView.image = backgroundImage
            }

            self.highlightArrowDelegate?.highlightArrow(self.isHighlighted)
        }
    }

    public var nextLabel = UILabel()
    public var hintLabel = UITextView()
    public var separator = UIView()

    //MARK: - Private properties
    private let backgroundImage = UIImage(named: "background", in: Bundle(for: CoachMarkBodyDefaultView.self), compatibleWith: nil)

    private let highlightedBackgroundImage = UIImage(named: "background-highlighted", in: Bundle(for: CoachMarkBodyDefaultView.self), compatibleWith: nil)

    private let backgroundImageView: UIImageView

    //MARK: - Initialization
    override public init (frame: CGRect) {
        self.backgroundImageView = UIImageView(image: self.backgroundImage)

        super.init(frame: frame)

        self.setupInnerViewHierarchy()
    }

    convenience public init() {
        self.init(frame: CGRect.zero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }
    
    public init (frame: CGRect, hintText: String, nextText: String?) {
        self.backgroundImageView = UIImageView(image: self.backgroundImage)
        
        super.init(frame: frame)
        
        if let next = nextText {
            self.hintLabel.text = hintText
            self.nextLabel.text = next
            self.setupInnerViewHierarchy()
        } else {
            self.hintLabel.text = hintText
            self.setupSimpleInnerViewHierarchy()
        }
    }
    
    convenience public init (hintText: String, nextText: String?) {
        
        self.init(frame: CGRect.zero, hintText: hintText, nextText: nextText)
    }

    //MARK: - Private properties
    //Configure the CoachMark view with a hint message and a next message
    private func setupInnerViewHierarchy() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundImageView.isUserInteractionEnabled = false

        self.addSubview(self.backgroundImageView)

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundImageView]|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["backgroundImageView": self.backgroundImageView]))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundImageView]|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["backgroundImageView": self.backgroundImageView]))


        hintLabel.backgroundColor = UIColor.clear()
        hintLabel.textColor = UIColor.darkGray()
        hintLabel.font = UIFont.systemFont(ofSize: 15.0)
        hintLabel.isScrollEnabled = false
        hintLabel.textAlignment = .justified
        hintLabel.layoutManager.hyphenationFactor = 2.0
        hintLabel.isEditable = false

        nextLabel.textColor = UIColor.darkGray()
        nextLabel.font = UIFont.systemFont(ofSize: 17.0)
        nextLabel.textAlignment = .center

        separator.backgroundColor = UIColor.gray()

        nextLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false

        nextLabel.isUserInteractionEnabled = false
        hintLabel.isUserInteractionEnabled = false
        separator.isUserInteractionEnabled = false

        self.addSubview(nextLabel)
        self.addSubview(hintLabel)
        self.addSubview(separator)

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nextLabel]|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["nextLabel": nextLabel]))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[hintLabel]-(5)-|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["hintLabel": hintLabel]))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(15)-[separator]-(15)-|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["separator": separator]))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[hintLabel]-(10)-[separator(==1)][nextLabel(==55)]|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["hintLabel": hintLabel, "separator": separator, "nextLabel": nextLabel]))
    }
    
    //Configure the CoachMark view with a hint message only
    private func setupSimpleInnerViewHierarchy() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundImageView.isUserInteractionEnabled = false
        
        self.addSubview(self.backgroundImageView)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundImageView]|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["backgroundImageView": self.backgroundImageView]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundImageView]|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["backgroundImageView": self.backgroundImageView]))
        
        hintLabel.backgroundColor = UIColor.clear()
        hintLabel.textColor = UIColor.darkGray()
        hintLabel.font = UIFont.systemFont(ofSize: 15.0)
        hintLabel.isScrollEnabled = false
        hintLabel.textAlignment = .justified
        hintLabel.layoutManager.hyphenationFactor = 2.0
        hintLabel.isEditable = false
        
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        
        hintLabel.isUserInteractionEnabled = false
        
        self.addSubview(hintLabel)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[hintLabel]-(5)-|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["hintLabel": hintLabel]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[hintLabel]-(10)-|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["hintLabel": hintLabel]))
    }
}
