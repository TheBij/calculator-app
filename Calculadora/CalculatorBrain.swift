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
    
    
    
    var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "(.)(.)" : Operation.Constant(80085),
        "???" : Operation.Constant(4815162342),
        "∞" : Operation.Constant(DBL_MAX),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "-" : Operation.UnaryOperation({ -$0 }),
        "!" : Operation.UnaryOperation({
            if $0 < 1 || $0 > 21 {return 1.0}
            var total = 1.0
            for num in 1...Int($0) {
                total = total * Double(num)
            }
            return total
        }),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "−" : Operation.BinaryOperation({ $0 - $1 }),
        "=" : Operation.Equals
        ]
    
    
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
                
            case .Constant(let value):
                accumulator = value
                
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
                
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                
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
    }
    
    
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    
    
}