//
//  OperationFactory.swift
//  CoalescingOperations-Example
//
//  Created by William Boles on 26/02/2026.
//  Copyright © 2026 Boles. All rights reserved.
//
import Foundation

protocol OperationFactory {
    func createExampleOperation(identifier: String,
                                completion: (OperationQueueManager.CompletionClosure)?) -> Operation
}

struct DefaultOperationFactory: OperationFactory {
    func createExampleOperation(identifier: String,
                                completion: (OperationQueueManager.CompletionClosure)?) -> Operation {
        let operation = CoalescingExampleOperation()
        operation.identifier = identifier
        operation.completion = completion
        
        return operation
    }
}
