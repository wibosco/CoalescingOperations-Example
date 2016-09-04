//
//  CoalescingOperation.swift
//  CoalescingOperations-Example
//
//  Created by Boles on 28/02/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

class CoalescingOperation: NSOperation {
    
    // MARK: Accessors

    var identifier: String?
    
    var completion: (QueueManager.CompletionClosure)?
    private var callBackQueue: NSOperationQueue
    
    // MARK: Init
    
    override init() {
        self.callBackQueue = NSOperationQueue.currentQueue()!
        
        super.init()
    }
    
    // MARK:
    
    override var asynchronous: Bool {
        return true
    }
    
    // MARK: - Completion
    
    func didComplete() {
        callBackQueue.addOperationWithBlock {
            if let completion = self.completion {
                completion(successful: true)
            }
        }
    }
}
