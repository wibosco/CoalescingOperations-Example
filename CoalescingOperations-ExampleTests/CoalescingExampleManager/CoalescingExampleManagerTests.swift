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
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager: queueManager, completion: nil)

        XCTAssertEqual(1, queueManager.numberOfTimesEnqueuedWasCalled)
    }
    
    func test_addExampleCoalescingOperation_onlyOneOperationAddedToQueueWithSameIdentifier() {
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager: queueManager, completion: nil)
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager: queueManager, completion: nil)
        
        XCTAssertEqual(1, queueManager.numberOfTimesEnqueuedWasCalled)
    }
    
    func test_addExampleCoalescingOperation_identifierUsedToCheckExistenceOnQueue() {
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager: queueManager, completion: nil)

        XCTAssertEqual("coalescingOperationExampleIdentifier", queueManager.operationIdentifier)
    }
    
    // MARK: Operation
    
    func test_addExampleCoalescingOperation_identifierAssignedToOperation() {
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager: queueManager, completion: nil)
        
        XCTAssertEqual("coalescingOperationExampleIdentifier", queueManager.enqueuedOperation.identifier)
    }
    
    // MARK: Callbacks
    
    func test_addExampleCoalescingOperation_identifierUsedWhenAddingClosureIfNonNil() {
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager: queueManager) { (successful) in
            
        }
        
        XCTAssertEqual("coalescingOperationExampleIdentifier", queueManager.completionIdentifier)
    }
    
    func test_addExampleCoalescingOperation_closureNotAddedIfNil() {
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager: queueManager, completion: nil)
        
        XCTAssertNil(queueManager.completionIdentifier)
    }
    
    func test_addExampleCoalescingOperation_multipleCallbacks() {
        let expectationA = expectation(description: "First callback")
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager: queueManager) { (successful) in
            expectationA.fulfill()
        }
        
        let expectationB = expectation(description: "Second callback")
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager: queueManager) { (successful) in
            expectationB.fulfill()
        }
        
        queueManager.triggeredEnqueuedOperationsCallbacks()
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    // MARK: Clear
    
    func test_addExampleCoalescingOperation_clear() {
        let expectation = expectation(description: "Multiple callbacks")
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager: queueManager) { (successful) in
            expectation.fulfill()
        }
        
        queueManager.triggeredEnqueuedOperationsCallbacks()
        
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertEqual("coalescingOperationExampleIdentifier", self.queueManager.clearIdentifier)
        }
    }
    
}
