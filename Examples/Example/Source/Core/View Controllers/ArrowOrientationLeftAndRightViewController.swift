//
//  ArrowOrientationLeftAndRightViewController.swift
//  Instructions Example
//
//  Created by liuliyang on 2018/5/30.
//  Copyright © 2018年 Ephread. All rights reserved.
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

class ArrowOrientationLeftAndRightViewController: ProfileViewController {

    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coachMarksController.dataSource = self
        
        self.emailLabel?.layer.cornerRadius = 4.0
        self.postsLabel?.layer.cornerRadius = 4.0
        self.reputationLabel?.layer.cornerRadius = 4.0
        
        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", for: .normal)
        
        self.coachMarksController.skipView = skipView
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension ArrowOrientationLeftAndRightViewController: CoachMarksControllerDataSource {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 2
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        switch(index) {
        case 0:
            var coachMark =  coachMarksController.helper.makeCoachMark(for: self.leftBtn)
            coachMark.arrowOrientation = .left
            return coachMark
        case 1:
            var coachMark =  coachMarksController.helper.makeCoachMark(for: self.rightBtn)
            coachMark.arrowOrientation = .right
            return coachMark
        default:
            return coachMarksController.helper.makeCoachMark()
        }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        var hintText = ""
        
        switch(index) {
        case 0:
            hintText = "left and right orientation should set with delegate, default orientation is top or bottom!"
        case 1:
            hintText = "left and right orientation should set with delegate, default orientation is top or bottom!"
        default: break
        }
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation, hintText: hintText, nextText: nil)
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}
