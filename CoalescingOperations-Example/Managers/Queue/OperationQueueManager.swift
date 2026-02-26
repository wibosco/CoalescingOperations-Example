//
//  QueueManager.swift
//  CoalescingOperations-Example
//
//  Created by Boles on 28/02/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

class OperationQueueManager: NSObject {
    
    typealias CompletionClosure = (_ successful: Bool) -> Void
    
    // MARK: - Accessors
    
    lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        
        return queue;
    }()
    
    lazy var completionClosures: [String: [CompletionClosure]] = {
        let completionClosures = [String: [CompletionClosure]]()
        
        return completionClosures
    }()
    
    // MARK: - SharedInstance
    
    static let sharedInstance = OperationQueueManager()
    
    // MARK: Addition
    
    func enqueue(operation: Operation) {
        queue.addOperation(operation)
    }
    
    // MARK: - ClosureManagement
    
    func addNewCompletionClosure(_ completion: @escaping (CompletionClosure), identifier: String) {
        var closures = completionClosures[identifier] ?? [CompletionClosure]()
        
        closures.append(completion)
        completionClosures[identifier] = closures
    }
    
    func completionClosures(forIdentifier identifier: String) -> [CompletionClosure]? {
        return completionClosures[identifier]
    }
    
    func operationIdentifierExistsOnQueue(forIdentifier identifier: String) -> Bool {
        let operations = self.queue.operations
        
        let identifiers = (operations as! [CoalescingOperation]).map{ $0.identifier }
        let exists = identifiers.contains(where: { identifier == $0 })
        
        return exists
    }
    
    func clearClosures(forIdentifier identifier: String) {
        completionClosures.removeValue(forKey: identifier)
    }
}
