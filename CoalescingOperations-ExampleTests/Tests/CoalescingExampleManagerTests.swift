//
//  CoalescingExampleManagerTests.swift
//  CoalescingOperations-Example
//
//  Created by William Boles on 26/08/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest

class CoalescingExampleManagerTests: XCTestCase {
    
    // MARK: - Accessors
    
    var queueManager: StubOperationQueueManager!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        queueManager = StubOperationQueueManager()
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
