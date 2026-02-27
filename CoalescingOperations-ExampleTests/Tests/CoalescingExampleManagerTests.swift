//
//  CoalescingExampleManagerTests.swift
//  CoalescingOperations-Example
//
//  Created by William Boles on 26/08/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest

class CoalescingExampleManagerTests: XCTestCase {
    var sut: CoalescingExampleManager!
    
    var queueManager: StubOperationQueueManager!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        queueManager = StubOperationQueueManager()
            
        sut = CoalescingExampleManager()
    }
    
    // MARK: - Tests
    
    // MARK: Added
    
    func test_addExampleCoalescingOperation_addedToQueue() {
        queueManager.operationIdentifierExistsOnQueueToReturn = false
        
        sut.addExampleCoalescingOperation(queueManager: queueManager,
                                          completion: nil)
        
        XCTAssertEqual(queueManager.events.count, 2)
        XCTAssertEqual(queueManager.events[0], .operationIdentifierExistsOnQueue("coalescingOperationExampleIdentifier"))
        
        guard case .enqueue(_) = queueManager.events[1] else {
            XCTFail("Unexpected event")
            return
        }
    }
    
    func test_addExampleCoalescingOperation_onlyOneOperationAddedToQueueWithSameIdentifier() {
        queueManager.operationIdentifierExistsOnQueueToReturn = true
        
        sut.addExampleCoalescingOperation(queueManager: queueManager,
                                          completion: nil)
        
        XCTAssertEqual(queueManager.events.count, 1)
        
        guard case .operationIdentifierExistsOnQueue(_) = queueManager.events[0] else {
            XCTFail("Unexpected event")
            return
        }
    }
    
    func test_addExampleCoalescingOperation_identifierUsedToCheckExistenceOnQueue() {
        sut.addExampleCoalescingOperation(queueManager: queueManager,
                                          completion: nil)

        guard case let .operationIdentifierExistsOnQueue(identifer) = queueManager.events[0] else {
            XCTFail("Unexpected event")
            return
        }
        
        XCTAssertEqual(identifer, "coalescingOperationExampleIdentifier")
    }
    
    // MARK: Operation
    
//    func test_addExampleCoalescingOperation_identifierAssignedToOperation() {
//        sut.addExampleCoalescingOperation(queueManager: queueManager,
//                                          completion: nil)
//        
//        XCTAssertEqual("coalescingOperationExampleIdentifier", queueManager.enqueuedOperation.identifier)
//    }
    
    // MARK: Callbacks
    
    func test_addExampleCoalescingOperation_identifierUsedWhenAddingClosureIfNonNil() {
        sut.addExampleCoalescingOperation(queueManager: queueManager) { (successful) in }
        
        XCTAssertEqual(, queueManager.completionIdentifier)
    }
    
//    func test_addExampleCoalescingOperation_closureNotAddedIfNil() {
//        sut.addExampleCoalescingOperation(queueManager: queueManager, completion: nil)
//        
//        XCTAssertNil(queueManager.completionIdentifier)
//    }
//    
//    func test_addExampleCoalescingOperation_multipleCallbacks() {
//        let expectationA = expectation(description: "First callback")
//        sut.addExampleCoalescingOperation(queueManager: queueManager) { (successful) in
//            expectationA.fulfill()
//        }
//        
//        let expectationB = expectation(description: "Second callback")
//        sut.addExampleCoalescingOperation(queueManager: queueManager) { (successful) in
//            expectationB.fulfill()
//        }
//        
//        queueManager.triggeredEnqueuedOperationsCallbacks()
//        
//        waitForExpectations(timeout: 2, handler: nil)
//    }
//    
//    // MARK: Clear
//    
//    func test_addExampleCoalescingOperation_clear() {
//        let expectation = expectation(description: "Multiple callbacks")
//        sut.addExampleCoalescingOperation(queueManager: queueManager) { (successful) in
//            expectation.fulfill()
//        }
//        
//        queueManager.triggeredEnqueuedOperationsCallbacks()
//        
//        waitForExpectations(timeout: 2) { (error) in
//            XCTAssertEqual("coalescingOperationExampleIdentifier", self.queueManager.clearIdentifier)
//        }
//    }
    
}
