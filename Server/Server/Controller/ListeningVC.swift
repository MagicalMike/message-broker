//
//  ListeningVC.swift
//  Server
//
//  Created by Mihai Petrenco on 10/30/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import SwiftSocket
import Cocoa

class ListeningVC: NSViewController {
    
    private(set) var server: TCPServer?
    private(set) var activityDelegate = ActivityDelegate()
    private(set) var activityDataSource = ActivityDataSource()
    private(set) var queueDelegate = QueueDelegate()
    private(set) var queueDataSource = QueueDataSource()
    
    
    @IBOutlet weak var activityTable: NSTableView!
    @IBOutlet weak var messageTable: NSTableView!
    
    override func viewDidLoad() {
        activityTable.delegate = activityDelegate
        activityTable.dataSource = activityDataSource
        messageTable.delegate = queueDelegate
        messageTable.dataSource = queueDataSource
        
        listen()
    }
    
    func listen() {
        
        DispatchQueue.global().async {
            while let client = self.server?.accept() {
                self.notifyConnection(client: client)
                
                while true {
                    if let response = client.read(1024) {
                        let command = self.decode(bytes: response)!.command
                        let message = self.decode(bytes: response)!.message
                        
                        self.notifyActivity(client: client, command: command, message: message)
                        self.process(client: client, command: command, message: message)
                        
                    }
                }
            }
        }
    }
    
    //Everytime a new user connects, notify the activity table
    func notifyConnection(client: TCPClient) {
        ContentStore.addActivity(by: client.address, with: "has connected")
        DispatchQueue.main.async {
            self.activityTable.reloadData()
        }
    }

    //In case of send/receive errors, display them in activity tables
    func notifyError(client: TCPClient, type: ErrorType) {
        ContentStore.addActivity(by: client.address, with: "could not \(type.rawValue) send data")
        DispatchQueue.main.async {
            self.activityTable.reloadData()
        }
    }
    
    //Post each message as an activity
    func notifyActivity(client: TCPClient, command: String, message: String) {
        if command == "Display" {
            ContentStore.addActivity(by: client.address, with: "asked for message publishing.")
        } else {
            ContentStore.addActivity(by: client.address, with: "added message to the queue.")
        }
        DispatchQueue.main.async {
            self.activityTable.reloadData()
        }
    }
    
    //Decode input from sender
    func decode(bytes: [Byte]) -> (command: String, message: String)? {
        
        let data = Data(bytes: bytes)
        
        guard let jsonObject = Serializer.deserialize(from: data) else {
            print("Could not deserialize JSON")
            return nil
        }
        
        guard let command = jsonObject[0]["Command"] as? String else {
            print("Could not obtain command.")
            return nil
        }
        
        guard let message = jsonObject[1]["Message"] as? String else {
            print("Could not obtain message")
            return nil
        }
        
        return (command,message)
    }
    
    //Process the input
    func process(client: TCPClient, command: String, message: String) {
        
        if command == "Send" {
            MessageStore.addMessage(message: message)
            DispatchQueue.main.async {
                self.messageTable.reloadData()
            }
        }
        
        if command == "Display" {
            publish(client: client, command: command, message: message)
        }
        
    }
    
    //Send first message from the queue
    func publish(client: TCPClient, command: String, message: String) {
        DispatchQueue.global().async {
            let data = Serializer.jsonData(with: command, message: message)
            let _ = client.send(data: data!)
        }
    }
    
    public func setServer(server: TCPServer) {
        self.server = server
    }
    
}
