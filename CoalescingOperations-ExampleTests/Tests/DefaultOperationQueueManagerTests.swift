//
//  OperationQueueManagerTests.swift
//  CoalescingOperations-Example
//
//  Created by William Boles on 24/08/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest

class DefaultOperationQueueManagerTests: XCTestCase {
    var sut: DefaultOperationQueueManager!
    
    // MARK: Lifecycle
    
    override func setUp() {
        super.setUp()
        
        sut = DefaultOperationQueueManager()
    }
    
    // MARK: Tests
    
    // MARK: Enqueue
    
//    func test_enqueue_count() {
//        let operationA = Operation()
//        let operationB = Operation()
//        
//        sut.enqueue(operation: operationA)
//        sut.enqueue(operation: operationB)
//        
//        XCTAssertEqual(queueManager.queue.operationCount, 2)
//    }
//    
//    // MARK: AddNewCompletionClosure
//    
//    func test_addNewCompletionClosure_addClosure() {
//        sut.addNewCompletionClosure({ (successful) in
//            
//            }, identifier: "test_identifier")
//        
//        XCTAssertEqual(queueManager.completionClosures.count, 1)
//    }
//    
//    func test_addNewCompletionClosure_addMultipleUniqueClosures() {
//        sut.addNewCompletionClosure({ (successful) in
//            
//            }, identifier: "test_identifierA")
//        
//        sut.addNewCompletionClosure({ (successful) in
//            
//            }, identifier: "test_identifierB")
//        
//        XCTAssertEqual(queueManager.completionClosures.count, 2)
//    }
//    
//    func test_addNewCompletionClosure_addMultipleSameIdentifierClosures() {
//        sut.addNewCompletionClosure({ (successful) in
//            
//            }, identifier: "test_identifier")
//        
//        sut.addNewCompletionClosure({ (successful) in
//            
//            }, identifier: "test_identifier")
//        
//        XCTAssertEqual(queueManager.completionClosures.count, 1)
//    }
//    
//    // MARK: CompletedClosures
//    
//    func test_completedClosures_mutiple() {
//        let identifier = "test_identifier"
//        
//        sut.addNewCompletionClosure({ (successful) in
//            
//            }, identifier: identifier)
//        
//        sut.addNewCompletionClosure({ (successful) in
//            
//            }, identifier: identifier)
//        
//        sut.addNewCompletionClosure({ (successful) in
//            
//            }, identifier: "test_identifier_should_not_be_returned")
//        
//        let Closures = sut.completionClosures(forIdentifier: identifier)!
//        
//        XCTAssertEqual(2, Closures.count)
//    }
//    
//    // MARK: OperationIdentifierExistsOnQueue
//    
//    func test_operationIdentifierExistsOnQueue_added() {
//        let identifier = "test_identifier"
//        let operation = CoalescingOperation()
//        operation.identifier = identifier
//        sut.enqueue(operation: operation)
//        
//        XCTAssertTrue(sut.operationIdentifierExistsOnQueue(forIdentifier: identifier))
//    }
//    
//    func test_operationIdentifierExistsOnQueue_notAdded() {
//        let operation = CoalescingOperation()
//        operation.identifier = "test_identifier"
//        sut.enqueue(operation: operation)
//        
//        XCTAssertFalse(sut.operationIdentifierExistsOnQueue(forIdentifier: "test_identifier_not_on_queue"))
//    }
//    
//    // MARK: Clear
//    
//    func test_clearClosures_removedAll() {
//        let identifier = "test_identifier"
//        
//        sut.addNewCompletionClosure({ (successful) in
//            
//            }, identifier: identifier)
//        
//        sut.addNewCompletionClosure({ (successful) in
//            
//            }, identifier: identifier)
//        
//        sut.clearClosures(forIdentifier: identifier)
//        
//        XCTAssertEqual(0, sut.completionClosures.count)
//    }
}
