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
    
    // MARK: Main
    
    override func main() {
        super.main()
        
        sleep(1)
        
        didComplete()
    }
}
