//
//  MessagingVC.swift
//  Server
//
//  Created by Mihai Petrenco on 11/5/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Cocoa
import SwiftSocket

class MessagingVC: NSViewController {
    
    //MARK: - Outlet declarations
    @IBOutlet weak var queueBox: NSBox!
    @IBOutlet weak var expandButton: NSButton!
    @IBOutlet weak var boxLeading: NSLayoutConstraint!
    @IBOutlet weak var activityTable: NSTableView!
    @IBOutlet weak var queueTable: NSTableView!
    
    //MARK: - Variable declarations
    private let activityDelegate = ActivityDelegate()
    private let activityDataSource = ActivityDataSource()
    
    private let queueDelegate = QueueDelegate()
    private let queueDataSource = QueueDataSource()
    
    private var expandPressed = false
    private var accepting = true
    private var listening = true
    
    var previousVC: ConnectionVC?
    var server: TCPServer?
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        activityTable.delegate = activityDelegate
        activityTable.dataSource = activityDataSource
        queueTable.delegate = queueDelegate
        queueTable.dataSource = queueDataSource
        previousVC?.view.window?.close()
        queueTable.doubleAction = #selector(cellSelected(sender:))
        queueTable.target = self
        loadQueue()
        run()
    }
    
    override func viewDidAppear() {
        setupWindow()
    }
    
    //MARK: - User actions
    @IBAction func expandBtnPressed(_ sender: Any) {
        if expandPressed {
            animateBox(to: -170)
            expandPressed = false
            expandButton.image = NSImage(imageLiteralResourceName: "expand")
            return
        }
        animateBox(to: 0)
        expandPressed = true
        expandButton.image = NSImage(imageLiteralResourceName: "collapse")
    }
    
    //MARK: - UI-related functions
    @objc func cellSelected(sender: Any) {
        QueueStore.selectQueue(at: queueTable.selectedRow)
        let identifier = NSStoryboardSegue.Identifier("QueueVC")
        performSegue(withIdentifier: identifier, sender: self)
    }
    
    func animateBox(to x: CGFloat) {
        boxLeading.animator().constant = x
    }
    
    func setupWindow() {
        let window = self.view.window
        window?.backgroundColor = #colorLiteral(red: 0.2596075237, green: 0.2981915474, blue: 0.3495857716, alpha: 1)
        window?.isMovableByWindowBackground = true
        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .hidden
        window?.minSize = NSSize(width: 640, height: 480)
    }
    
    //MARK: - Server functionality
    
    //Start point and client connection
    func run() {
        DispatchQueue.global().async {
            while self.accepting {
                if let client = self.server?.accept() {
                    let color = NSColor(from: 50, with: 200)
                    self.notifyConnection(with: client, having: color)
                    self.listen(by: client, having: color)
                }
            }
        }
    }
    
    //Listening for incoming data
    func listen(by client: TCPClient, having color: NSColor) {
        DispatchQueue.global().async {
            while self.listening {
                if let input = client.read(1024) {
                    let data = Data(bytes: input)
                    guard let json = Serializer.toJSON(from: data) else {
                        self.notifyActivity(from: client, having: color, with: "Could not read JSON.")
                        return
                    }
                    self.process(json: json, from: client, having: color)
                }
            }
        }
    }
    
    //Decomposing the JSON dictionary into variables
    func process(json: [String:Any], from client: TCPClient, having color: NSColor) {
        
        guard let command = json["Command"] as? String else {
            return
        }
        guard let queues = json["Queues"] as? [String] else {
            return
        }
        guard let content = json["Content"] as? String else {
            return
        }
        
        switch getCommand(from: command) {
        case .put:
            self.putFunctionality(from: client, with: content, in: queues)
            self.notifyActivity(from: client, having: color, with: "Added message to queues.")
        case .count:
            self.countFunctionality(from: client, at: queues)
            self.notifyActivity(from: client, having: color, with: "Asked for queue count.")
        case .remove:
            self.removeFunctionality(from: client, at: queues)
            self.notifyActivity(from: client, having: color, with: "Removed message from queue.")
        case .get:
            self.getFunctionality(from: client, at: queues)
            self.notifyActivity(from: client, having: color, with: "Asked for queue contents.")
        case .subscribe:
            self.subscribeFunctionality(from: client, at: queues)
            self.notifyActivity(from: client, having: color, with: "Subscribed to queues.")
        default:
            print("Unknown shit")
        }
    }
    
    //Function that executes when sender asked for PUT command
    func putFunctionality(from client: TCPClient, with content: String, in queues:[String]) {
        for queue in queues {
            QueueStore.add(contents: content, in: queue)
            self.refreshQueue()
            self.checkSubscriber(at: queue)
        }
        
        let json = Serializer.generate(with: "RESPONSE", and: "Message added in \(queues) succesfully!")
        guard let data = Serializer.toData(from: json) else {
            print("Error at " + #function)
            return
        }
        let _ = client.send(data: data)
        
    }
    
    //Function that executes when sender asked for COUNT command
    func countFunctionality(from client: TCPClient, at queues: [String]) {
        var content = "[ "
        for i in QueueStore.queues {
            for j in queues {
                if i.name == j {
                    content += "\(i.name) = \(i.contents.count) "
                }
            }
        }
        content += "]"
        
        let json = Serializer.generate(with: "RESPONSE", and: content)
        guard let data = Serializer.toData(from: json) else {
            print("Error at " + #function)
            return
        }
        let _ = client.send(data: data)
    }
    
    //Function executed when REMOVE command is selected
    func removeFunctionality(from client: TCPClient, at queues: [String]) {
        for index in 0..<QueueStore.queues.count {
            for element in queues {
                if QueueStore.queues[index].name == element {
                    QueueStore.remove(at: index)
                }
            }
        }
        QueueStore.cleanup()
        self.refreshQueue()
        
        let json = Serializer.generate(with: "RESPONSE", and: "Has removed messages from queues.")
        guard let data = Serializer.toData(from: json) else {
            print("Error at " + #function)
            return
        }
        let _ = client.send(data: data)
    }
    
    //Function executed when GET command is selected
    func getFunctionality(from client: TCPClient, at queues: [String]) {
        var contents = "[ "
        
        for i in QueueStore.queues {
            for j in queues {
                if i.name == j && i.contents.count > 0 {
                    contents += "\(i.name) = \(i.contents.last!) "
                }
            }
        }
        contents += " ]"
        let json = Serializer.generate(with: "RESPONSE", and: contents)
        guard let data = Serializer.toData(from: json) else {
            print("Error at " + #function)
            return
        }
        let _ = client.send(data: data)
    }
    
    //Function executed when SUBSCRIBE command is selected
    func subscribeFunctionality(from client: TCPClient, at queues: [String]) {
        for queue in queues {
            QueueStore.addSubscriber(for: queue, client: client)
        }
    }
    
    //Subscriber functionalities
    func checkSubscriber(at queue: String) {
        for element in QueueStore.queues {
            if element.name == queue {
                for subscriber in element.subscribers {
                    let json = Serializer.generate(with: "RESPONSE", and: element.contents.last!)
                    let data = Serializer.toData(from: json)
                    let _ = subscriber.send(data: data!)
                }
            }
        }
    }

    //Function that loads the contents of the queue
    func loadQueue() {
        QueueStore.load()
        DispatchQueue.main.async {
            self.queueTable.reloadData()
        }
    }
    
    //Converts raw String format into Command enums
    func getCommand(from raw: String) -> Command {
        switch raw {
        case "GET":
            return .get
        case "PUT":
            return .put
        case "COUNT":
            return .count
        case "REMOVE":
            return .remove
        case "SUBSCRIBE":
            return .subscribe
        case "RESPONSE":
            return .response
        case "ERROR":
            return .error
        default:
            print("Error at " + #function)
        }
        return .none
    }
    
    //Function notifies whenever a connection has been made
    func notifyConnection(with client: TCPClient, having color: NSColor) {
        ActivityStore.addActivity(by: client.address, having: color, with: "has connected")
        DispatchQueue.main.async {
            self.activityTable.reloadData()
        }
    }
    
    //Asynchronously reload the table contents
    func refreshQueue() {
        DispatchQueue.main.async {
            self.queueTable.reloadData()
        }
    }
    
    //Notifies whenever an activity takes place
    func notifyActivity(from client: TCPClient, having color: NSColor, with message: String) {
        ActivityStore.addActivity(by: client.address, having: color, with: message)
        DispatchQueue.main.async {
            self.activityTable.reloadData()
        }
    }
}
