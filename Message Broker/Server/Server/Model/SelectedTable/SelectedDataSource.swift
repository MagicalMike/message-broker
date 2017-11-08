//
//  SelectedDataSource.swift
//  Server
//
//  Created by Mihai Petrenco on 11/6/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class SelectedDataSource: NSObject, NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return QueueStore.selectedQueue.count
    }
    
}
