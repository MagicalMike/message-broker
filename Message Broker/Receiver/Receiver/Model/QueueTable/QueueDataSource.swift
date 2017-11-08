//
//  QueueDataSource.swift
//  Sender
//
//  Created by Mihai Petrenco on 11/2/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class QueueDataSource: NSObject, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return QueueStore.queues.count
    }
   
}
