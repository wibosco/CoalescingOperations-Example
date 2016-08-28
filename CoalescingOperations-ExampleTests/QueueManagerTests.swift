//
//  QueueManagerTests.swift
//  CoalescingOperations-Example
//
//  Created by William Boles on 24/08/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest

class QueueManagerTests: XCTestCase {
    
    // MARK: Accessors
    
    var queueManager: QueueManager!
    
    // MARK: Lifecycle
    
    override func setUp() {
        super.setUp()
        
        queueManager = QueueManager()
    }
    
    // MARK: Tests
    
    // MARK: Enqueue
    
    func test_enqueue_count() {
        let operationA = NSOperation()
        let operationB = NSOperation()
        
        queueManager.enqueue(operationA)
        queueManager.enqueue(operationB)
        
        XCTAssertEqual(queueManager.queue.operationCount, 2)
    }
    
    // MARK: AddNewCompletionClosure
    
    func test_addNewCompletionClosure_addClosure() {
        queueManager.addNewCompletionClosure({ (successful) in
            
            }, identifier: "test_identifier")
        
        XCTAssertEqual(queueManager.completionClosures.count, 1)
    }
    
    func test_addNewCompletionClosure_addMultipleUniqueClosures() {
        queueManager.addNewCompletionClosure({ (successful) in
            
            }, identifier: "test_identifierA")
        
        queueManager.addNewCompletionClosure({ (successful) in
            
            }, identifier: "test_identifierB")
        
        XCTAssertEqual(queueManager.completionClosures.count, 2)
    }
    
    func test_addNewCompletionClosure_addMultipleSameIdentifierClosures() {
        queueManager.addNewCompletionClosure({ (successful) in
            
            }, identifier: "test_identifier")
        
        queueManager.addNewCompletionClosure({ (successful) in
            
            }, identifier: "test_identifier")
        
        XCTAssertEqual(queueManager.completionClosures.count, 1)
    }
    
    // MARK: CompletedClosures
    
    func test_completedClosures_mutiple() {
        let identifier = "test_identifier"
        
        queueManager.addNewCompletionClosure({ (successful) in
            
            }, identifier: identifier)
        
        queueManager.addNewCompletionClosure({ (successful) in
            
            }, identifier: identifier)
        
        queueManager.addNewCompletionClosure({ (successful) in
            
            }, identifier: "test_identifier_should_not_be_returned")
        
        let Closures = queueManager.completionClosures(identifier)!
        
        XCTAssertEqual(2, Closures.count)
    }
    
    // MARK: OperationIdentifierExistsOnQueue
    
    func test_operationIdentifierExistsOnQueue_added() {
        let identifier = "test_identifier"
        let operation = CoalescingOperation()
        operation.identifier = identifier
        queueManager.enqueue(operation)
        
        XCTAssertTrue(queueManager.operationIdentifierExistsOnQueue(identifier))
    }
    
    func test_operationIdentifierExistsOnQueue_notAdded() {
        let operation = CoalescingOperation()
        operation.identifier = "test_identifier"
        queueManager.enqueue(operation)
        
        XCTAssertFalse(queueManager.operationIdentifierExistsOnQueue("test_identifier_not_on_queue"))
    }
    
    // MARK: Clear
    
    func test_clearClosures_removedAll() {
        let identifier = "test_identifier"
        
        queueManager.addNewCompletionClosure({ (successful) in
            
            }, identifier: identifier)
        
        queueManager.addNewCompletionClosure({ (successful) in
            
            }, identifier: identifier)
        
        queueManager.clearClosures(identifier)
        
        XCTAssertEqual(0, queueManager.completionClosures.count)
    }
}
