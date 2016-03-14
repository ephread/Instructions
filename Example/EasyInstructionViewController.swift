// DefaultViewController.swift
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
import Instructions

// That's the default controller, using every defaults made available by Instructions.
// It can't get any simpler.
class EasyInstructionViewController: ProfileViewController{
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailLabel?.layer.cornerRadius = 4.0
        self.postsLabel?.layer.cornerRadius = 4.0
        self.reputationLabel?.layer.cornerRadius = 4.0
        
        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", forState: .Normal)
        self.coachMarksController?.skipView = skipView
        
        let easyInstruction = EasyInstruction()
        easyInstruction.setParentController(self)
        easyInstruction.addInstruction(self.handleLabel!, text: self.profileSectionText)
        easyInstruction.addInstruction(self.postsLabel!, text: self.handleText)
        easyInstruction.addInstruction(self.reputationLabel!, text: self.reputationText)
        easyInstruction.setNextButtonText("NEXT")
        easyInstruction.setCloseButtonText("CLOSE")
        easyInstruction.setSkipView(skipView)
        
    }
    
    
}
