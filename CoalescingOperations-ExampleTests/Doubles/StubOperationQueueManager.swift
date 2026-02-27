//
//  StubOperationQueueManager.swift
//  CoalescingOperations-ExampleTests
//
//  Created by William Boles on 26/02/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

final class StubOperationQueueManager: OperationQueueManager {
    enum Event: Equatable {
        case operationIdentifierExistsOnQueue(String)
        case addNewCompletionClosure(CompletionClosure, String)
        case completionClosures(String)
        case enqueue(Operation)
        case clearClosures(String)
        
        static func == (lhs: Event, rhs: Event) -> Bool {
            switch (lhs, rhs) {
            case let (.operationIdentifierExistsOnQueue(lhsID), .operationIdentifierExistsOnQueue(rhsID)):
                return lhsID == rhsID
            case let (.addNewCompletionClosure(_, lhsID), .addNewCompletionClosure(_, rhsID)):
                return lhsID == rhsID
            case let (.completionClosures(lhsID), .completionClosures(rhsID)):
                return lhsID == rhsID
            case let (.enqueue(lhsOp), .enqueue(rhsOp)):
                return lhsOp == rhsOp
            case let (.clearClosures(lhsID), .clearClosures(rhsID)):
                return lhsID == rhsID
            default:
                return false
            }
        }
    }
    
    private(set) var events: [Event] = []
    
    var operationIdentifierExistsOnQueueToReturn = false
    var completionClosuresToReturn = [CompletionClosure]()
    
    // MARK: - Overrides
    
    func operationIdentifierExistsOnQueue(forIdentifier identifier: String) -> Bool {
        events.append(.operationIdentifierExistsOnQueue(identifier))
        
        return operationIdentifierExistsOnQueueToReturn
    }
    
    func addNewCompletionClosure(_ completion: @escaping (CompletionClosure), identifier: String) {
        events.append(.addNewCompletionClosure(completion, identifier))
    }
    
    func completionClosures(forIdentifier identifier: String) -> [CompletionClosure]? {
        events.append(.completionClosures(identifier))
        
        return completionClosuresToReturn
    }
    
    func enqueue(operation: Operation) {
        events.append(.enqueue(operation))
    }
    
    func clearClosures(forIdentifier identifier: String) {
        events.append(.clearClosures(identifier))
    }
}
