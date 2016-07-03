// CoachMarkBodyView.swift
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

/// A protocol to which all the "body views" of a coach mark must conform.
public protocol CoachMarkBodyView : class {
    /// The control that will trigger the change between the current coach mark
    /// and the next one.
    var nextControl: UIControl? { get }

    /// A delegate to call, when the arrow view to mirror the current highlight
    /// state of the body view. This is useful in case the entier view is actually a `UIControl`.
    ///
    /// The `CoachMarkView`, of which the current view must be
    /// part, will automatically set itself as the delegate and will take care
    /// of fowarding the state to the arrow view.
    weak var highlightArrowDelegate: CoachMarkBodyHighlightArrowDelegate? { get set }
}
