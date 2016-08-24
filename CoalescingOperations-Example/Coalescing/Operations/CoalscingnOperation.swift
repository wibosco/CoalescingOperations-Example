//
//  QuestionsRetrievalOperation.swift
//  CoalescingOperations-Example
//
//  Created by Boles on 28/02/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

class CoalscingOperation: NSOperation {
    
    //MARK: Accessors

    var completion : ((successful: Bool) -> (Void))?
    var callBackQueue : NSOperationQueue
    
    //MARK: Init
    
    init(completion: ((successful: Bool) -> Void)?) {
        self.completion = completion
        self.callBackQueue = NSOperationQueue.currentQueue()!
        
        super.init()
    }
    
    //MARK: Main
    
    override func main() {
        super.main()
        
        sleep(1)
        
        if let completion = completion {
            completion(successful: true)
        }
        
    }
}
