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
    
    // MARK: - AsynchronousSupport
    
    private var _executing: Bool = false
    override var executing: Bool {
        get {
            return _executing
        }
        set {
            if _executing != newValue {
                willChangeValueForKey("isExecuting")
                _executing = newValue
                didChangeValueForKey("isExecuting")
            }
        }
    }
    
    private var _finished: Bool = false;
    override var finished: Bool {
        get {
            return _finished
        }
        set {
            if _finished != newValue {
                willChangeValueForKey("isFinished")
                _finished = newValue
                didChangeValueForKey("isFinished")
            }
        }
    }
    
    override var asynchronous: Bool {
        return true
    }
    
    // MARK: - Lifecycle
    
    override func start() {
        if cancelled {
            finish()
            return
        } else {
            executing = true;
            finished = false;
        }
    }
    
    private func finish() {
        executing = false
        finished = true
    }
    
    // MARK: - Completion
    
    func didComplete() {
        finish()
        
        callBackQueue.addOperationWithBlock {
            if let completion = self.completion {
                completion(successful: true)
            }
        }
    }
}
