//
//  CoalescingExampleManagerTests.swift
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

class CoalescingExampleManagerTests: XCTestCase {
    
    // MARK: - Accessors
    
    var queueManager: QueueManagerSpy!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        queueManager = QueueManagerSpy()
    }
    
    // MARK: - Tests
    
    // MARK: Added
    
    func test_addExampleCoalescingOperation_addedToQueue() {
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager, completion: nil)

        XCTAssertEqual(1, queueManager.numberOfTimesEnqueuedWasCalled)
    }
    
    func test_addExampleCoalescingOperation_onlyOneOperationAddedToQueueWithSameIdentifier() {
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager, completion: nil)
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager, completion: nil)
        
        XCTAssertEqual(1, queueManager.numberOfTimesEnqueuedWasCalled)
    }
    
    func test_addExampleCoalescingOperation_identifierUsedToCheckExistenceOnQueue() {
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager, completion: nil)

        XCTAssertEqual("coalescingOperationExampleIdentifier", queueManager.operationIdentifier)
    }
    
    // MARK: Operation
    
    func test_addExampleCoalescingOperation_identifierAssignedToOperation() {
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager, completion: nil)
        
        XCTAssertEqual("coalescingOperationExampleIdentifier", queueManager.enqueuedOperation.identifier)
    }
    
    // MARK: Callbacks
    
    func test_addExampleCoalescingOperation_identifierUsedWhenAddingClosureIfNonNil() {
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager) { (successful) in
            
        }
        
        XCTAssertEqual("coalescingOperationExampleIdentifier", queueManager.completionIdentifier)
    }
    
    func test_addExampleCoalescingOperation_closureNotAddedIfNil() {
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager, completion: nil)
        
        XCTAssertNil(queueManager.completionIdentifier)
    }
    
    func test_addExampleCoalescingOperation_multipleCallbacks() {
        let expectationA = expectationWithDescription("First callback")
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager) { (successful) in
            expectationA.fulfill()
        }
        
        let expectationB = expectationWithDescription("Second callback")
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager) { (successful) in
            expectationB.fulfill()
        }
        
        queueManager.triggeredEnqueuedOperationsCallbacks()
        
        waitForExpectationsWithTimeout(2, handler: nil)
    }
    
    // MARK: Clear
    
    func test_addExampleCoalescingOperation_clear() {
        let expectation = expectationWithDescription("Multiple callbacks")
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager) { (successful) in
            expectation.fulfill()
        }
        
        queueManager.triggeredEnqueuedOperationsCallbacks()
        
        waitForExpectationsWithTimeout(2) { (error) in
            XCTAssertEqual("coalescingOperationExampleIdentifier", self.queueManager.clearIdentifier)
        }
    }
    
}
