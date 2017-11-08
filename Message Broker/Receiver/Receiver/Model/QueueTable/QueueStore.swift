//
//  QueueStore.swift
//  Sender
//
//  Created by Mihai Petrenco on 11/2/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation

class QueueStore {
    
    private(set) static var queues = ["Main"]
    
    public static func addQueue(named: String) {
        queues.append(named)
    }
    
    public static func remove() {
        if queues.count > 1 {
            let _  = queues.popLast()
        }
    }
}
