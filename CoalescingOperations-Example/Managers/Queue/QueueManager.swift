//
//  QueueManager.swift
//  CoalescingOperations-Example
//
//  Created by Boles on 28/02/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

class QueueManager: NSObject {
    
    typealias CompletionClosure = (successful: Bool) -> Void
    
    // MARK: - Accessors
    
    lazy var queue: NSOperationQueue = {
        let queue = NSOperationQueue()
        
        return queue;
    }()
    
    lazy var completionBlocks: [String: [CompletionClosure]] = {
        let completionBlocks = [String: [CompletionClosure]]()
        
        return completionBlocks
    }()
    
    // MARK: - SharedInstance
    
    static let sharedInstance = QueueManager()
    
    // MARK: - Callbacks
    
    func addNewCompletionBlock(completion: (CompletionClosure), identifier: String) {
        var blocks = completionBlocks[identifier]
        
        if blocks == nil {
            blocks = [CompletionClosure]()
        }
        
        blocks!.append(completion)
        completionBlocks[identifier] = blocks!
    }
    
    func completionBlocks(identifier: String) -> [CompletionClosure]? {
        return completionBlocks[identifier]
    }
    
    // MARK: Existing
    
    func operationIdentifierExistsOnQueue(identifier: String) -> Bool {
        let operations = self.queue.operations
        
        let identifiers = (operations as! [CoalscingOperation]).map{$0.identifier}
        let exists = identifiers.contains({ identifier == $0 })
        
        return exists
    }
    
    // MARK: Clear
    
    func clearBlocks(identifier: String) {
        completionBlocks.removeValueForKey(identifier)
    }
}
