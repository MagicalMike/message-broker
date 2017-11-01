//
//  ReceiverVC.swift
//  Receiver
//
//  Created by Mihai Petrenco on 10/31/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa
import SwiftSocket

class ReceiverVC: NSViewController {
    
    @IBOutlet weak var messageTable: NSTableView!
    @IBOutlet weak var commandBox: NSPopUpButton!
    @IBOutlet weak var messageTextfield: NSTextField!
    
    private(set) var client: TCPClient?
    
    private(set) var delegate = MessageDelegate()
    private(set) var dataSource = MessageDataSource()
    
    override func viewDidLoad() {
        
        messageTable.delegate = delegate
        messageTable.dataSource = dataSource
        
        MessageStore.reset()
        messageTable.reloadData()
        
        listen()
    }
    
    override func viewDidAppear() {
        self.view.window?.title = "Receiver"
        self.view.window?.minSize = NSSize(width: 300, height: 400)
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        
        let currentCommand = returnCommand()
        let message = messageTextfield.stringValue
        
        guard let data = processRequest(with: currentCommand) else {
            return
        }
        
        let response = client?.send(data: data)
        switch response {
        case .some(_):
            MessageStore.addMessage(command: currentCommand, message: message)
        case .none:
            MessageStore.addError(content: "Could not send data.")
        }
        messageTable.reloadData()
    }
    
    func listen() {
        DispatchQueue.global().async {
            while true {
                if let input = self.client?.read(1024, timeout: 2000) {
                    let data = Data(bytes: input)
                    if let json = Serializer.toJSON(from: data) {
                        self.notifyActivity(json: json)
                    }
                }
            }
        }
    }
    
    func processRequest(with command: Command) -> Data?{
        
        let content = messageTextfield.stringValue
        let type = Type.all
        let command = command
        
        guard let jsonObj = Serializer.createJSON(type: type, command: command, content: content) else {
            print("Could not generate JSON object")
            return nil
        }
        
        guard let data = Serializer.toData(from: jsonObj) else {
            print("Could not convert JSON to Data")
            return nil
        }
        return data
    }
    
    func notifyActivity(json: [String:Any]) {
        
        guard let command = json["Command"] as? String else {
            MessageStore.addMessage(command: .error, message: "Could not decode JSON.")
            DispatchQueue.main.async {
                self.messageTable.reloadData()
            }
            return
        }
        
        guard let content = json["Content"] as? String else {
            MessageStore.addMessage(command: .error, message: "Could not decode JSON.")
            DispatchQueue.main.async {
                self.messageTable.reloadData()
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
            self.messageTable.reloadData()
        }
    }
    
    func returnCommand() -> Command {
        if commandBox.titleOfSelectedItem == "GET" {
            return .get
        }
        
        if commandBox.titleOfSelectedItem == "COUNT" {
            return .count
        }
        
        if commandBox.titleOfSelectedItem == "SUBSCRIBE" {
            return .subscribe
        }
        return .none
    }
    
    func setClient(client: TCPClient) {
        self.client = client
    }
}
