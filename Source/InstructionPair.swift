//
//  InstructionPair.swift
//  Instructions
//
//  Created by youyue on 14/3/16.
//  Copyright © 2016 Ephread. All rights reserved.
//

import Foundation

internal class InstructionPair{
    private var view : UIView?
    private var text : String?
    
    init(view: UIView, text : String){
        self.view = view
        self.text = text
    }
    
    func getView() -> UIView{
        if(view == nil){
            fatalError("Not initialize view in Instruction Pair")
        }
        
        return self.view!
    }
    
    func getText() -> String{
        if(text == nil){
            fatalError("Not initialize view in Instruction Pair")
        }
        
        return self.text!
    }
}
