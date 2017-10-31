//
//  MessageDelegate.swift
//  Receiver
//
//  Created by Mihai Petrenco on 10/31/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class MessageDelegate: NSObject, NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cell = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
        
        if (tableColumn?.identifier)!.rawValue == "IPAddress" {
            cell.textField?.attributedStringValue = MessageStore.messages[row].address
        } else {
            cell.textField?.stringValue = MessageStore.messages[row].content
        }
        return cell
    }
    
}
