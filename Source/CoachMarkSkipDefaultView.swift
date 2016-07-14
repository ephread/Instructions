// CoachMarkSkipDefaultView.swift
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

/// A concrete implementation of the coach mark skip view and the
/// default one provided by the library.
public class CoachMarkSkipDefaultView : UIButton, CoachMarkSkipView {
    //MARK: - Public properties
    public var skipControl: UIControl? {
        get {
            return self
        }
    }

    //MARK: - Private properties
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public convenience init() {
        self.init(frame: CGRect.zero)

        self.setTitleColor(UIColor.black(), for: UIControlState())
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        self.titleLabel?.textAlignment = .center

        self.setBackgroundImage(UIImage(named: "background", in: Bundle(for: CoachMarkSkipDefaultView.self), compatibleWith: nil), for: UIControlState())
        self.setBackgroundImage(UIImage(named: "background-highlighted", in: Bundle(for: CoachMarkSkipDefaultView.self), compatibleWith: nil), for: .highlighted)

        self.layer.cornerRadius = 4
        self.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
        self.sizeToFit()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }
}
