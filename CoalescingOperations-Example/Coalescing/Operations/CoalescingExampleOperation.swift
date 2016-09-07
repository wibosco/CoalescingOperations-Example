//
//  CoalescingExampleOperation.swift
//  CoalescingOperations-Example
//
//  Created by William Boles on 04/09/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

/**
 An example subclass of a coalescible operation.
 */
class CoalescingExampleOperation: CoalescingOperation {
    
    // MARK: Start
    
    override func start() {
        super.main()
        
        sleep(1)
        
        didComplete()
    }
}
