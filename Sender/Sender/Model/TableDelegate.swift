//
//  TableDelegate.swift
//  Sender
//
//  Created by Mihai Petrenco on 10/30/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class TableDelegate: NSObject, NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as? NSTableCellView {
            cell.textField?.attributedStringValue = MessageStore.messages[row]
            return cell
        }
        return nil
    }
    
}
