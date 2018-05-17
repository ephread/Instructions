// CoachMarkArrowDefaultView.swift
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

// MARK: - Default Class
/// A concrete implementation of the coach mark arrow view and the
/// default one provided by the library.
public class CoachMarkArrowDefaultView: UIView, CoachMarkArrowView {
    // MARK: - Initialization
    var orientation:CoachMarkArrowOrientation = CoachMarkArrowOrientation.top
    public var color:UIColor = UIColor.red {
        didSet {
            self.layoutIfNeeded()
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public init(orientation: CoachMarkArrowOrientation) {
        self.orientation = orientation
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
//        let image, highlightedImage: UIImage?
//
//        if orientation == .top {
//            image = UIImage(namedInInstructions: "arrow-top")
//            highlightedImage = UIImage(namedInInstructions: "arrow-top-highlighted")
//        } else {
//            image = UIImage(namedInInstructions: "arrow-bottom")
//            highlightedImage = UIImage(namedInInstructions: "arrow-bottom-highlighted")
//        }
        
//        super.init(image: image, highlightedImage: highlightedImage)

        initializeConstraints()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }
    public var isHighlighted: Bool = false

    override public func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(self.color.cgColor)
        context?.setFillColor(self.color.cgColor)
        switch self.orientation {
        case .top:
            //        left down corner
            context?.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            //        top middle point
            context?.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            //        right down corner
            context?.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        case .bottom:
            context?.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context?.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            context?.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            
//        case .left:
//            context?.move(to: CGPoint(x: rect.minX, y: rect.midY))
//            context?.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
//            context?.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
//
//        case .right:
//            context?.move(to: CGPoint(x: rect.minX, y: rect.minY))
//            context?.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
//            context?.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        default:
            return
        }
        context?.closePath()
        context?.drawPath(using: .fillStroke)
        context?.strokePath()
    }
}
// MARK: - Private Inner Setup
private extension CoachMarkArrowDefaultView {
    func initializeConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        switch self.orientation {
        case .top,.bottom:
            self.widthAnchor.constraint(equalToConstant: Constants.arrowViewDefaultWidth).isActive = true
            self.heightAnchor.constraint(equalToConstant: Constants.arrowViewDefaultHeight).isActive = true
//        case .left,.right:
//            self.widthAnchor.constraint(equalToConstant: Constants.arrowViewDefaultHeight).isActive = true
//            self.heightAnchor.constraint(equalToConstant: Constants.arrowViewDefaultWidth).isActive = true
        default:
            return
        }
    }
}
