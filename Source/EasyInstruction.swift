//
//  EasyInstructionController.swift
//  Instructions
//
//  Created by youyue on 14/3/16.
//  Copyright © 2016 Ephread. All rights reserved.
//

import UIKit
public class EasyInstruction: UIViewController,CoachMarksControllerDataSource {
    
    //MARK: - Public properties
    private var coachMarksController: CoachMarksController?
    private var markedView : UIView?
    private var displayText = ""
    private var nextButtonText = "Next"
    private var closeButtonText = "Close"
    private var instructionSet = [InstructionPair]()
    //MARK: - View lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.coachMarksController = CoachMarksController()
        self.coachMarksController?.allowOverlayTap = true
        self.coachMarksController?.dataSource = self
    }
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.coachMarksController?.startOn(self)
    }
    //public api
    public func addInstruction(presentView: UIView, text : String){
        self.instructionSet.append(InstructionPair(view: presentView,text: text))
    }
    
    public func setParentController(parentController: UIViewController){
        parentController.addChildViewController(self)
        parentController.view.addSubview(self.view)
    }
    
    public func setSkipView(skipView : CoachMarkSkipView){
        self.coachMarksController?.skipView = skipView
    }
    
    public func setNextButtonText(text :String){
        self.nextButtonText = text
    }
    
    public func setCloseButtonText(text:String){
        self.closeButtonText = text
    }
    
    //MARK: - Protocol Conformance | CoachMarksControllerDataSource
    public func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return instructionSet.count
    }
    
    public func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        
        let view = instructionSet[index].getView()
        return coachMarksController.coachMarkForView(view)
    }
    
    public func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        
        let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)
        coachViews.bodyView.hintLabel.text = self.instructionSet[index].getText()
        
        if(index != instructionSet.count - 1){
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        }
        else{
            coachViews.bodyView.nextLabel.text = self.closeButtonText
        }
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}
