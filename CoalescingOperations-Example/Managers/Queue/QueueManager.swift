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
    
    lazy var completionClosures: [String: [CompletionClosure]] = {
        let completionClosures = [String: [CompletionClosure]]()
        
        return completionClosures
    }()
    
    // MARK: - SharedInstance
    
    static let sharedInstance = QueueManager()
    
    // MARK: - Callbacks
    
    func addNewCompletionClosure(completion: (CompletionClosure), identifier: String) {
        var closures = completionClosures[identifier]
        
        if closures == nil {
            closures = [CompletionClosure]()
        }
        
        closures!.append(completion)
        completionClosures[identifier] = closures!
    }
    
    func completionClosures(identifier: String) -> [CompletionClosure]? {
        return completionClosures[identifier]
    }
    
    // MARK: Existing
    
    func operationIdentifierExistsOnQueue(identifier: String) -> Bool {
        let operations = self.queue.operations
        
        let identifiers = (operations as! [CoalscingOperation]).map{$0.identifier}
        let exists = identifiers.contains({ identifier == $0 })
        
        return exists
    }
    
    // MARK: Clear
    
    func clearClosures(identifier: String) {
        completionClosures.removeValueForKey(identifier)
    }
}
