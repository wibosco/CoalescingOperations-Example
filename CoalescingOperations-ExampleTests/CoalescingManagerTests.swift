//
//  CoalescingManagerTests.swift
//  CoalescingOperations-Example
//
//  Created by William Boles on 26/08/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest

class QueueManagerMock: QueueManager {
    
}

class CoalescingManagerTests: XCTestCase {
    
    // MARK: Accessors
    
    
    
    // MARK: Lifecycle
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Tests
    
    // MARK: Callbacks
    
    func test_addCoalescingOperation_multipleCallBacks() {
        let queueManager = QueueManager()
        CoalescingManager.addCoalescingOperation(queueManager) { (successful) in
            
        }
        
        CoalescingManager.addCoalescingOperation(queueManager) { (successful) in
            
        }
    }
    
}
