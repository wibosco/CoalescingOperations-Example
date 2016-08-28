//
//  CoalscingManager.swift
//  CoalescingOperations-Example
//
//  Created by Boles on 28/02/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

class CoalescingManager: NSObject {
    
    // MARK: - Add
    
    class func addCoalescingOperation(queueManager: QueueManager = QueueManager.sharedInstance, completion: (QueueManager.CompletionClosure)?) {
        let coalescingOperationExampleIdentifier = "coalescingOperationExampleIdentifier"
        
        if let completion = completion {
            queueManager.addNewCompletionClosure(completion, identifier: coalescingOperationExampleIdentifier)
        }
        
        if !queueManager.operationIdentifierExistsOnQueue(coalescingOperationExampleIdentifier) {
            let operation = CoalescingOperation()
            operation.identifier = coalescingOperationExampleIdentifier
            operation.completion = {(successful) in
                let closures = queueManager.completionClosures(coalescingOperationExampleIdentifier)
                
                if let closures = closures {
                    for closure in closures {
                        closure(successful: successful)
                    }
                    
                    queueManager.clearClosures(coalescingOperationExampleIdentifier)
                }
            }
            
            queueManager.enqueue(operation)
        }
    }
}
