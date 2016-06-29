//
//  ViewController.swift
//  Calculadora
//
//  Created by Bijan Khosraviani on 6/20/16.
//  Copyright © 2016 Bij. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    
    
    
    
    
    @IBAction private func touchDigit(sender: UIButton) {
        
        if let digit = sender.currentTitle {
            
            // don't let user type decimal twice
            if (display.text!.rangeOfString(".") == nil) || (digit != "." || !userIsInTheMiddleOfTyping) {
                
                if userIsInTheMiddleOfTyping {
                    display.text = display.text! + digit
                }
                else {
                    digit == "." ? (display.text = "0" + digit) : (display.text = digit)
                    userIsInTheMiddleOfTyping = true
                }
                
            }
            
            
        }
    }
    
    
    
    
    
    var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalOperation = sender.currentTitle {
            brain.performOperation(mathematicalOperation)
        }
        
        displayValue = brain.result
    }
    

}

















