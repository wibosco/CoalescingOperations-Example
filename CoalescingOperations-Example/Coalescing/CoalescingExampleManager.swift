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
class CoalescingExampleManager: NSObject {
    
    // MARK: - Add
    
    class func addExampleCoalescingOperation(queueManager: QueueManager = QueueManager.sharedInstance, completion: (QueueManager.CompletionClosure)?) {
        let coalescingOperationExampleIdentifier = "coalescingOperationExampleIdentifier"
        
        if let completion = completion {
            queueManager.addNewCompletionClosure(completion, identifier: coalescingOperationExampleIdentifier)
        }
        
        if !queueManager.operationIdentifierExistsOnQueue(forIdentifier: coalescingOperationExampleIdentifier) {
            let operation = CoalescingExampleOperation()
            operation.identifier = coalescingOperationExampleIdentifier
            operation.completion = {(successful) in
                let closures = queueManager.completionClosures(forIdentifier: coalescingOperationExampleIdentifier)
                
                if let closures = closures {
                    for closure in closures {
                        closure(successful)
                    }
                    
                    queueManager.clearClosures(forIdentifier: coalescingOperationExampleIdentifier)
                }
            }
            
            queueManager.enqueue(operation: operation)
        }
    }
}
