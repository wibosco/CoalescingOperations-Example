//
//  QuestionsRetrievalOperation.swift
//  CoalescingOperations-Example
//
//  Created by Boles on 28/02/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

class CoalscingOperation: NSOperation {
    
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
    
    // MARK: Main
    
    override func main() {
        super.main()
        
        sleep(1)
        
        if let completion = completion {
            completion(successful: true)
        }
        
    }
}
