//
//  ActivityDelegate.swift
//  Sender
//
//  Created by Mihai Petrenco on 11/2/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class ActivityDelegate: NSObject, NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as? NSTableCellView
        
        if tableColumn?.identifier.rawValue == "IPAddress" {
            cell?.textField?.attributedStringValue = ActivityStore.activities[row].address
        }
        
        if tableColumn?.identifier.rawValue == "Activity" {
            cell?.textField?.stringValue = ActivityStore.activities[row].content
        }
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 35.0
    }
    
}
