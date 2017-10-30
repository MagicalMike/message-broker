//
//  ViewController.swift
//  Sender
//
//  Created by Mihai Petrenco on 10/30/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Cocoa
import SwiftSocket

class MessagingVC: NSViewController {
    
    private(set) var client: TCPClient?
    
    let delegate = TableDelegate()
    let dataSource = TableDataSource()
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var sendButton: NSButton!
    @IBOutlet weak var messageField: NSTextField!
    @IBOutlet weak var commandBtn: CommandButton!
    
    private var selectedCommand = "Send"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        selectedCommand = commandBtn.titleOfSelectedItem!
    }
    
    @IBAction func commandBtnChanged(_ sender: Any) {
        selectedCommand = commandBtn.titleOfSelectedItem!
        
        if selectedCommand == "Display" {
            messageField.isEnabled = false
            messageField.backgroundColor = NSColor.gray
        } else {
            messageField.isEnabled = true
            messageField.backgroundColor = NSColor.white
        }
        
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        let message = messageField.stringValue
        MessageStore.addMessage(command: selectedCommand, message: message)
        
        tableView.reloadData()
        messageField.stringValue = ""
    }
    
    public func setClient(client: TCPClient) {
        self.client = client
    }
}

