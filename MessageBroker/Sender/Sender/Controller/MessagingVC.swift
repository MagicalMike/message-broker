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
    @IBOutlet weak var commandBtn: NSPopUpButton!
    
    private var selectedCommand: Command = .put
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        MessageStore.reset()
        tableView.reloadData()
        
        listen()
    }
    
    override func viewDidAppear() {
        self.view.window?.minSize = NSSize(width: 300, height: 400)
    }
    
    func listen() {
        DispatchQueue.global().async {
            while true {
                if let input = self.client?.read(1024) {
                    let data = Data(bytes: input)
                    if let json = Serializer.toJSON(from: data) {
                        self.notifyActivity(json: json)
                    }
                }
            }
        }
    }
    
    func notifyActivity(json: [String:Any]) {
        
        guard let command = json["Command"] as? String else {
            MessageStore.addMessage(command: .error, message: "Could not decode JSON.")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            return
        }
        
        guard let content = json["Content"] as? String else {
            MessageStore.addMessage(command: .error, message: "Could not decode JSON.")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            return
        }
        
        switch command {
        case "RESPONSE":
            MessageStore.addMessage(command: .response, message: content)
        case "ERROR":
            MessageStore.addMessage(command: .error, message: content)
        default:
            print("Unknown command")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func commandBtnChanged(_ sender: Any) {
        title = commandBtn.titleOfSelectedItem!
        
        if title == "PUT" {
            messageField.isEnabled = true
            messageField.backgroundColor = NSColor.white
            selectedCommand = .put
        }
        
        if title == "COUNT" {
            messageField.isEnabled = false
            messageField.backgroundColor = NSColor.gray
            selectedCommand = .count
        }
        
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        
        let content = messageField.stringValue
        guard let json = Serializer.createJSON(type: Type.all, command: selectedCommand, content: content) else {
            return
        }
        
        guard let data = Serializer.toData(from: json) else {
            return
        }
        
        let result = client?.send(data: data)
        
        switch result {
        case .some(_):
            MessageStore.addMessage(command: selectedCommand, message: content)
            
        case .none:
            MessageStore.addError(with: "Error while sending data.")
        }
        tableView.reloadData()
    }
    
    
    public func setClient(client: TCPClient) {
        self.client = client
    }

}

