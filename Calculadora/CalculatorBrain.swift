//
//  CalculatorBrain.swift
//  Calculadora
//
//  Created by Bijan Khosraviani on 6/20/16.
//  Copyright © 2016 Bij. All rights reserved.
//

import Foundation


class CalculatorBrain {
    
    
    
    private var accumulator = 0.0
    
    
    var description: String {
        get {
            if pending == nil {
                return descriptionAccumulator
            }
            else {
                return pending!.descriptionFunction(pending!.descriptionOperand, pending!.descriptionOperand != descriptionAccumulator ? descriptionAccumulator : "")
            }
        }
    }
    private var descriptionAccumulator = "0"
    
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "(.)(.)" : Operation.Constant(80085),
        "???" : Operation.Constant(4815162342),
        "∞" : Operation.Constant(DBL_MAX),
        "√" : Operation.UnaryOperation(sqrt, {"√("+$0+")"}),
        "cos" : Operation.UnaryOperation(cos, {"cos("+$0+")"}),
        "-" : Operation.UnaryOperation({ -$0 }, {"-"+$0}),
        "!" : Operation.UnaryOperation({
            if $0 < 1 || $0 > 21 {return 1.0}
            var total = 1.0
            for num in 1...Int($0) {
                total = total * Double(num)
            }
            return total
            }, {"("+$0+")!"}),
        "×" : Operation.BinaryOperation({ $0 * $1 }, {$0+"×"+$1}),
        "÷" : Operation.BinaryOperation({ $0 / $1 }, {$0+"÷"+$1}),
        "+" : Operation.BinaryOperation({ $0 + $1 }, {$0+"+"+$1}),
        "−" : Operation.BinaryOperation({ $0 - $1 }, {$0+"−"+$1}),
        "=" : Operation.Equals
        ]
    
    
    
    
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double, (String) -> String)
        case BinaryOperation((Double, Double) -> Double, (String, String) -> String)
        case Equals
    }
    
    
    
    
    
    func setOperand(operand: Double) {
        accumulator = operand
        descriptionAccumulator = String(format: "%g", operand)
    }
    
    
    
    
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
                
            case .Constant(let value):
                accumulator = value
                descriptionAccumulator = symbol
                
            case .UnaryOperation(let function, let descriptionFunction):
                accumulator = function(accumulator)
                descriptionAccumulator = descriptionFunction(descriptionAccumulator)
                
            case .BinaryOperation(let function, let descriptionFunction):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator, descriptionFunction: descriptionFunction, descriptionOperand: descriptionAccumulator)
                
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    
    
    
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    
    
    
    private var pending: PendingBinaryOperationInfo?
    
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        var descriptionFunction: (String, String) -> String
        var descriptionOperand: String
    }
    
    
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    
}