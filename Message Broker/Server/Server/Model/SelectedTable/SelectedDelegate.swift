//
//  SelectedDelegate.swift
//  Server
//
//  Created by Mihai Petrenco on 11/6/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class SelectedDelegate: NSObject, NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
        cell.textField?.stringValue = QueueStore.selectedQueue[row]
        return cell
    }
    
}
