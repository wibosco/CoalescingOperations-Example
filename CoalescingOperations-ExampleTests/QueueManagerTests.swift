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
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    // MARK: Tests
    
    // MARK: AddNewCompletionBlock
    
    func test_addNewCompletionBlock_addBlock() {
        queueManager.addNewCompletionBlock({ (successful) in
            
            }, identifier: "test_identifier")
        
        XCTAssertEqual(queueManager.completionBlocks.count, 1)
    }
    
    func test_addNewCompletionBlock_addMultipleUniqueBlocks() {
        queueManager.addNewCompletionBlock({ (successful) in
            
            }, identifier: "test_identifierA")
        
        queueManager.addNewCompletionBlock({ (successful) in
            
            }, identifier: "test_identifierB")
        
        XCTAssertEqual(queueManager.completionBlocks.count, 2)
    }
    
    func test_addNewCompletionBlock_addMultipleSameIdentifierBlocks() {
        queueManager.addNewCompletionBlock({ (successful) in
            
            }, identifier: "test_identifier")
        
        queueManager.addNewCompletionBlock({ (successful) in
            
            }, identifier: "test_identifier")
        
        XCTAssertEqual(queueManager.completionBlocks.count, 1)
    }
    
    // MARK: CompletedBlocks
    
    func test_completedBlocks_mutiple() {
        let identifier = "test_identifier"
        
        queueManager.addNewCompletionBlock({ (successful) in
            
            }, identifier: identifier)
        
        queueManager.addNewCompletionBlock({ (successful) in
            
            }, identifier: identifier)
        
        queueManager.addNewCompletionBlock({ (successful) in
            
            }, identifier: "test_identifier_should_not_be_returned")
        
        let blocks = queueManager.completionBlocks(identifier)!
        
        XCTAssertEqual(2, blocks.count)
    }
    
    // MARK: OperationIdentifierExistsOnQueue
    
    func test_operationIdentifierExistsOnQueue_added() {
        let identifier = "test_identifier"
        let operation = CoalscingOperation()
        operation.identifier = identifier
        queueManager.queue.addOperation(operation)
        
        XCTAssertTrue(queueManager.operationIdentifierExistsOnQueue(identifier))
    }
    
    func test_operationIdentifierExistsOnQueue_notAdded() {
        let operation = CoalscingOperation()
        operation.identifier = "test_identifier"
        queueManager.queue.addOperation(operation)
        
        XCTAssertTrue(queueManager.operationIdentifierExistsOnQueue("test_identifier_not_on_queue"))
    }
}
