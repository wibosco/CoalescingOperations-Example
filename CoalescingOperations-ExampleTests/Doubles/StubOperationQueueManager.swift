//
//  StubOperationQueueManager.swift
//  CoalescingOperations-ExampleTests
//
//  Created by William Boles on 26/02/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

final class StubOperationQueueManager: OperationQueueManager {
    var operationIdentifier: String!
    var completionIdentifier: String!
    var clearIdentifier: String!
    var enqueuedOperation: CoalescingOperation!
    var numberOfTimesEnqueuedWasCalled = 0
    var closures = [CompletionClosure]()
    
    // MARK: - Overrides
    
    override func operationIdentifierExistsOnQueue(forIdentifier identifier: String) -> Bool {
        operationIdentifier = identifier
        
        return numberOfTimesEnqueuedWasCalled > 0
    }
    
    override func addNewCompletionClosure(_ completion: @escaping (CompletionClosure), identifier: String) {
        completionIdentifier = identifier
        
        closures.append(completion)
    }
    
    override func completionClosures(forIdentifier identifier: String) -> [CompletionClosure]? {
        return closures
    }
    
    override func enqueue(operation: Operation) {
        enqueuedOperation = operation as! CoalescingOperation
        
        numberOfTimesEnqueuedWasCalled += 1
    }
    
    override func clearClosures(forIdentifier identifier: String) {
        clearIdentifier = identifier
        super.clearClosures(forIdentifier: identifier)
    }
    
    // MARK: - Simulated
    
    func triggeredEnqueuedOperationsCallbacks() {
        if let completion = enqueuedOperation.completion {
            completion(true)
        }
    }
}
