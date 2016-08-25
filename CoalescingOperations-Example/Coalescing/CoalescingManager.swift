//
//  CoalscingAPIManager.swift
//  CoalescingOperations-Example
//
//  Created by Boles on 28/02/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

class CoalescingManager: NSObject {
    
    // MARK: - Add
    
    class func addCoalescingOperation(completion:(QueueManager.CompletionClosure)?) {
        let coalescingOperationExampleIdentifier = "coalescingOperationExampleIdentifier"
        
        if let completion = completion {
            QueueManager.sharedInstance.addNewCompletionClosure(completion, identifier: coalescingOperationExampleIdentifier)
        }
        
        if QueueManager.sharedInstance.operationIdentifierExistsOnQueue(coalescingOperationExampleIdentifier) {
            
            let operation = CoalscingOperation()
            operation.identifier = coalescingOperationExampleIdentifier
            operation.completion = {(successful) in
                let closures = QueueManager.sharedInstance.completionClosures(coalescingOperationExampleIdentifier)
                
                if let closures = closures {
                    for closure in closures {
                        closure(successful: successful)
                    }
                    
                    QueueManager.sharedInstance.clearClosures(coalescingOperationExampleIdentifier)
                }
            }
            
            QueueManager.sharedInstance.queue.addOperation(operation)
        }
    }
}
