//
//  QueueStore.swift
//  Sender
//
//  Created by Mihai Petrenco on 11/2/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import SwiftSocket

class QueueStore {
    
    //MARK: - Variable declarations
    
    private(set) static var queues = [(name: "Main", subscribers: [TCPClient](), contents: [String]())]
    
    
    private(set) static var selectedQueue = [String]()
    
    //MARK: - Function implementation
    
    //This adds a new element to the queue or creates a new queue
    public static func add(contents: String, in queue: String) {
        
        for index in 0..<queues.count {
            if queues[index].name == queue {
                queues[index].contents.append(contents)
                return
            }
        }
        queues.append((name: queue,subscribers: [TCPClient](), contents: [contents]))
    }
    
    
    
    //Sets the selected queue to the one at the specified index
    public static func selectQueue(at index: Int) {
        selectedQueue = queues[index].contents
    }
    
    //This removes an element from the index specified
    public static func remove(at index: Int) {
        if queues[index].contents.count > 0 {
            let _ = queues[index].contents.removeLast()
        }
    }
    
    //Cleanup deletes the queue once it has no more elements
    public static func cleanup() {
        var index = 0
        while true {
            if queues[index].contents.count == 0 && index != 0 {
                queues.remove(at: index)
            } else {
                index += 1
            }
            if index >= queues.count {
                return
            }
        }
    }
    
    //This adds a new subscriber to the list of subscriber if his IP address is not already there
    public static func addSubscriber(for queue: String, client: TCPClient) {
        for index in 0..<queues.count {
            if queues[index].name == queue {
                for subscriber in queues[index].subscribers {
                    if subscriber.address != client.address {
                        return
                    }
                }
                queues[index].subscribers.append(client)
            }
        }
    }
    
    //Saves the Message Queues as a JSON object
    public static func save() {
        let desktopDir = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)
        let fileDir = desktopDir.first!.appendingPathComponent("MessageQueue.json")
        
        guard let data = Serializer.convert(queue: QueueStore.queues) else {
            print("Could not obtain convert queue to Data")
            return
        }
        
        do {
            try data.write(to: fileDir)
        } catch {
            print("Could not save JSON to file")
        }
    }
    
    //Loads the JSON object and setups the arrays
    public static func load() {
        let desktopDir = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)
        let fileDir = desktopDir.first!.appendingPathComponent("MessageQueue.json")
        
        do {
            let data = try Data(contentsOf: fileDir)
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard let origin = json as? [[[String:Any]]] else {
                print("Could not parse JSON.")
                return
            }
            
            var array = [(String,[TCPClient],[String])]()

            for element in origin {
                let name = element[0]["Name"] as! String
                let contents = element[1]["Contents"] as! [String]
                let collection = (name:name,subscribers: [TCPClient](), contents:contents)
                array.append(collection)
            }
            queues = array
            
        } catch {
            print("No data has been saved")
        }
    }
}
