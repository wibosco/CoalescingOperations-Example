//
//  CoalescingManagerTests.swift
//  CoalescingOperations-Example
//
//  Created by William Boles on 26/08/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest

class QueueManagerSpy: QueueManager {
    
    var operationIdentifier: String!
    var completionIdentifier: String!
    var clearIdentifier: String!
    var enqueuedOperation: CoalescingOperation!
    var numberOfTimesEnqueuedWasCalled = 0
    var closures = [CompletionClosure]()
    
    // MARK: - Overrides
    
    override func operationIdentifierExistsOnQueue(identifier: String) -> Bool {
        operationIdentifier = identifier
        
        return numberOfTimesEnqueuedWasCalled > 0
    }
    
    override func addNewCompletionClosure(completion: (CompletionClosure), identifier: String) {
        completionIdentifier = identifier
        
        closures.append(completion)
    }
    
    override func completionClosures(identifier: String) -> [CompletionClosure]? {
        return closures
    }
    
    override func enqueue(operation: NSOperation) {
        enqueuedOperation = operation as! CoalescingOperation
        
        numberOfTimesEnqueuedWasCalled += 1
    }
    
    override func clearClosures(identifier: String) {
        clearIdentifier = identifier
        super.clearClosures(identifier)
    }
    
    // MARK: - Simulated
    
    func triggeredEnqueuedOperationsCallbacks() {
        if let completion = enqueuedOperation.completion {
            completion(successful: true)
        }
    }
}

class CoalescingManagerTests: XCTestCase {
    
    // MARK: - Accessors
    
    var queueManager: QueueManagerSpy!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        queueManager = QueueManagerSpy()
    }
    
    // MARK: - Tests
    
    // MARK: Added
    
    func test_addCoalescingOperation_addedToQueue() {
        CoalescingManager.addCoalescingOperation(queueManager, completion: nil)

        XCTAssertEqual(1, queueManager.numberOfTimesEnqueuedWasCalled)
    }
    
    func test_addCoalescingOperation_onlyOneOperationAddedToQueueWithSameIdentifier() {
        CoalescingManager.addCoalescingOperation(queueManager, completion: nil)
        CoalescingManager.addCoalescingOperation(queueManager, completion: nil)
        
        XCTAssertEqual(1, queueManager.numberOfTimesEnqueuedWasCalled)
    }
    
    func test_addCoalescingOperation_identifierUsedToCheckExistenceOnQueue() {
        CoalescingManager.addCoalescingOperation(queueManager, completion: nil)

        XCTAssertEqual("coalescingOperationExampleIdentifier", queueManager.operationIdentifier)
    }
    
    // MARK: Operation
    
    func test_addCoalescingOperation_identifierAssignedToOperation() {
        CoalescingManager.addCoalescingOperation(queueManager, completion: nil)
        
        XCTAssertEqual("coalescingOperationExampleIdentifier", queueManager.enqueuedOperation.identifier)
    }
    
    // MARK: Callbacks
    
    func test_addCoalescingOperation_identifierUsedWhenAddingClosureIfNonNil() {
        CoalescingManager.addCoalescingOperation(queueManager) { (successful) in
            
        }
        
        XCTAssertEqual("coalescingOperationExampleIdentifier", queueManager.completionIdentifier)
    }
    
    func test_addCoalescingOperation_closureNotAddedIfNil() {
        CoalescingManager.addCoalescingOperation(queueManager, completion: nil)
        
        XCTAssertNil(queueManager.completionIdentifier)
    }
    
    func test_addCoalescingOperation_multipleCallbacks() {
        let expectationA = expectationWithDescription("First callback")
        CoalescingManager.addCoalescingOperation(queueManager) { (successful) in
            expectationA.fulfill()
        }
        
        let expectationB = expectationWithDescription("Second callback")
        CoalescingManager.addCoalescingOperation(queueManager) { (successful) in
            expectationB.fulfill()
        }
        
        queueManager.triggeredEnqueuedOperationsCallbacks()
        
        waitForExpectationsWithTimeout(20, handler: nil)
    }
    
    // MARK: Clear
    
    func test_addCoalescingOperation_clear() {
        let expectation = expectationWithDescription("Multiple callbacks")
        CoalescingManager.addCoalescingOperation(queueManager) { (successful) in
            expectation.fulfill()
        }
        
        queueManager.triggeredEnqueuedOperationsCallbacks()
        
        waitForExpectationsWithTimeout(2) { (error) in
            XCTAssertEqual("coalescingOperationExampleIdentifier", self.queueManager.clearIdentifier)
        }
    }
    
}
