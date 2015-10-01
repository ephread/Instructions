// Instructions.swift
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

import Foundation

/// Execute some code after a given delay
///
/// From [Matt Neuburg](http://stackoverflow.com/users/341994/matt), on
/// [Stack Overflow](http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift/24318861#24318861)
///
/// - Parameter delay: the time to wait before executing
/// - Parameter closure: the closure to execute
public func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

let kOverlayFadeAnimationDuration: NSTimeInterval = 0.3;
let kCoachMarkFadeAnimationDuration: NSTimeInterval = 0.3;
let kOverlayColor = UIColor(red: 226.0/255.0, green: 226.0/255.0, blue: 226.0/255.0, alpha: 0.65);
