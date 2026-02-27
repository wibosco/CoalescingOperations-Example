//
//  CoalescingExampleManager.swift
//  CoalescingOperations-Example
//
//  Created by Boles on 28/02/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

/**
 An example manager that handles queuing operations.
 
 It exists as we don't really want our VCs to know anything about coalescing or the queue.
 */
class WorkQueue {
    private let operationFactory: OperationFactory
    
    private let queue = OperationQueue()
    private var completionItems = [String: [() -> ()]]()
    
    private let serialQueue = DispatchQueue(label: "workQueue")
    
    // MARK: - Init
    
    init(operationFactory: OperationFactory) {
        self.operationFactory = operationFactory
    }
    
    // MARK: - Add
    
    func scheduleWork(identifier: String,
                      completion: @escaping (() -> ())) {
        serialQueue.async { [self] in
            let shouldCreateOperation = completionItems[identifier]?.isEmpty ?? true
            completionItems[identifier, default: []].append(completion)
            
            if shouldCreateOperation {
                let operation = operationFactory.createExampleOperation(identifier: identifier) { [self] successful in
                    serialQueue.async { [self] in
                        for completion in completionItems[identifier] ?? [] {
                            completion()
                        }
                        completionItems[identifier] = nil
                    }
                }
                
                queue.addOperation(operation)
            }
        }
    }
}

class WorkQueue2 {
    private let operationFactory: OperationFactory
    
    private let queue = OperationQueue()
    private var completionItems = [String: [() -> ()]]()
    
    private let serialQueue = DispatchQueue(label: "workQueue")
    
    // MARK: - Init
    
    init(operationFactory: OperationFactory) {
        self.operationFactory = operationFactory
    }
    
    // MARK: - Add
    
    func scheduleWork<T>(identifier: String,
                      work: @escaping
                      completion: @escaping ((T) -> ())) {
        serialQueue.async { [self] in
            let shouldCreateOperation = completionItems[identifier]?.isEmpty ?? true
            completionItems[identifier, default: []].append(completion)
            
            if shouldCreateOperation {
                let operation = operationFactory.createExampleOperation(identifier: identifier) { [self] successful in
                    serialQueue.async { [self] in
                        for completion in completionItems[identifier] ?? [] {
                            completion()
                        }
                        completionItems[identifier] = nil
                    }
                }
                
                queue.addOperation(operation)
            }
        }
    }
}
