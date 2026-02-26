//
//  CoalescingOperation.swift
//  CoalescingOperations-Example
//
//  Created by Boles on 28/02/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

class CoalescingOperation: Operation {
    
    // MARK: Accessors

    var identifier: String?
    
    var completion: (OperationQueueManager.CompletionClosure)?
    private var callBackQueue: OperationQueue
    
    // MARK: Init
    
    override init() {
        self.callBackQueue = OperationQueue.current ?? OperationQueue.main
        
        super.init()
    }
    
    // MARK: - AsynchronousSupport
    
    private var _executing: Bool = false
    override var isExecuting: Bool {
        get {
            return _executing
        }
        set {
            if _executing != newValue {
                willChangeValue(forKey: "isExecuting")
                _executing = newValue
                didChangeValue(forKey: "isExecuting")
            }
        }
    }
    
    private var _finished: Bool = false;
    override var isFinished: Bool {
        get {
            return _finished
        }
        set {
            if _finished != newValue {
                willChangeValue(forKey: "isFinished")
                _finished = newValue
                didChangeValue(forKey: "isFinished")
            }
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    // MARK: - Lifecycle
    
    override func start() {
        if isCancelled {
            finish()
            return
        } else {
            isExecuting = true;
            isFinished = false;
        }
    }
    
    private func finish() {
        isExecuting = false
        isFinished = true
    }
    
    // MARK: - Completion
    
    func didComplete() {
        finish()
        
        callBackQueue.addOperation {
            if let completion = self.completion {
                completion(true)
            }
        }
    }
}
