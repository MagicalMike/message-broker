//
//  MessageDataSource.swift
//  Receiver
//
//  Created by Mihai Petrenco on 10/31/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class MessageDataSource: NSObject, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return MessageStore.messages.count
    }
    
}
