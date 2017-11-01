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
        
        acceptConnections()
    }
    
    override func viewDidAppear() {
        self.view.window?.title = "Server"
        self.view.window?.minSize = NSSize(width: 500, height: 400)
    }
    
    func acceptConnections() {
        DispatchQueue.global().async {
            while true {
                if let client = self.server?.accept() {
                    let color = NSColor(random: true)
                    self.notifyConnection(client: client, color: color)
                    self.listen(client: client, color: color)
                }
            }
        }
    }
    
    func listen(client: TCPClient, color: NSColor) {
        DispatchQueue.global().async {
            while true {
                if let input = client.read(1024) {
                    let data = Data(bytes: input)
                    if let json = Serializer.toJSON(from: data) {
                        self.notifyActivity(client: client, color: color, json: json)
                        self.process(client: client, color: color, json: json)
                    }
                }
            }
        }
    }
    
    func process(client: TCPClient, color:NSColor, json: [String:Any]) {
        
        guard let command = json["Command"] as? String else {
            return
        }
        
        guard let content = json["Content"] as? String else {
            return
        }
        
        switch command {
        case "PUT":
            self.notifyQueue(content: content)
            let message = "Message succesfully added!"
            let json = Serializer.createJSON(type: .all, command: .response, content: message)
            let data = Serializer.toData(from: json!)
            if data != nil {
                let _ = client.send(data: data!) // response
            }
            
        case "GET":
            
            var data: Data?
            
            if let message = MessageStore.getMessage() {
                let json = Serializer.createJSON(type: .all, command: .response, content: message)
                data = Serializer.toData(from: json!)
            } else {
                let errorMessage = "Message queue is empty!"
                let json = Serializer.createJSON(type: .all, command: .error, content: errorMessage)
                data = Serializer.toData(from: json!)
            }
            
            if data != nil {
                let _ = client.send(data: data!) // response
            }
           
        case "COUNT":
            
            let size = String(MessageStore.messages.count)
            let json = Serializer.createJSON(type: .all, command: .response, content: size)
            let data = Serializer.toData(from: json!)
            if data != nil {
                let _ = client.send(data: data!) // response
            }
            
        case "SUBSCRIBE":
            ActivityStore.addActivity(by: "SERVER", having: color, with: "Subscribing not implemented.")
            let errorMessage = "Subscribing not yet implemented."
            let json = Serializer.createJSON(type: .all, command: .error, content: errorMessage)
            let data = Serializer.toData(from: json!)
            if data != nil {
                let _ = client.send(data: data!) // response
            }
            
        default:
            print("Unknown command.")
        }
        
    }
    
    func notifyQueue(content: String) {
        MessageStore.addMessage(message: content)
        DispatchQueue.main.async {
            self.messageTable.reloadData()
        }
    }

    func notifyConnection(client: TCPClient, color: NSColor) {
        ActivityStore.addActivity(by: client.address, having: color, with: "has connected.")
        DispatchQueue.main.async {
            self.activityTable.reloadData()
        }
    }
    
    func notifyActivity(client: TCPClient, color: NSColor, json: [String:Any]) {
        guard let command = json["Command"] as? String else {
            ActivityStore.addActivity(by: client.address, having: color, with: "failed to read received JSON.")
            DispatchQueue.main.async {
                self.activityTable.reloadData()
            }
            return
        }
        
        switch command {
        case "PUT":
            ActivityStore.addActivity(by: client.address, having: color, with: "added message to queue.")
        case "COUNT":
            ActivityStore.addActivity(by: client.address, having: color, with: "asked for queue size.")
        case "GET":
            ActivityStore.addActivity(by: client.address, having: color, with: "asked for queue message.")
        case "SUBSCRIBE":
            ActivityStore.addActivity(by: client.address, having: color, with: "wants to subscribe to queue.")
        default:
            print("Unknown command")
        }
        
        DispatchQueue.main.async {
            self.activityTable.reloadData()
        }
    }
    
    func setServer(server: TCPServer) {
        self.server = server
    }
    
}
