//
//  ActivityDelegate.swift
//  Server
//
//  Created by Mihai Petrenco on 10/31/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class ActivityDelegate: NSObject, NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cell = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as? NSTableCellView
        
        if tableColumn?.identifier.rawValue == "IPAddress" {
            cell?.textField?.attributedStringValue = ActivityStore.activities[row].address
        } else {
            cell?.textField?.stringValue = ActivityStore.activities[row].content
        }
        return cell
    }
    
}
