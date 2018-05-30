//
//  ArrowOrientationLeftAndRightViewController.swift
//  Instructions Example
//
//  Created by liuliyang on 2018/5/30.
//  Copyright © 2018年 Ephread. All rights reserved.
//

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
            coachMark.maxWidth = 250
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
            hintText = "left and right orientation should set with delegate, and if too much info, you should set coachMark.maxWidth with delegate too!"
        case 1:
            hintText = "default orientation is top or bottom"
        default: break
        }
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation, hintText: hintText, nextText: nil)
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}
