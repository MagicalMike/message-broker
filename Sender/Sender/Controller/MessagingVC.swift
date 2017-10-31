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
        MessageStore.reset()
        tableView.reloadData()
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
        
        let data = Serializer.jsonData(with: selectedCommand, message: message)!
        
        do {
            guard let obj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:AnyObject]] else {
                return print("F1")
            }
            
            guard let mess = obj[1] as? [String:String] else {
                return print("F2")
            }
            
            guard let message = mess["Message"] else {
                return print("F3")
            }
            
            print(message)
            
        } catch {
            
        }
        
        let _ = client?.send(data: data)

        messageField.stringValue = ""
    }
    
    public func setClient(client: TCPClient) {
        self.client = client
    }
}

