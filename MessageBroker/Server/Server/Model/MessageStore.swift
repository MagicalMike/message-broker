//
//  MessageStore.swift
//  Server
//
//  Created by Mihai Petrenco on 10/31/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation

class MessageStore {
    private(set) static var messages = [String]()
    
    static func addMessage(message: String) {
        messages.append(message)
    }
    
    static func getMessage() -> String? {
        if messages.count > 0 {
            return messages.last
        }
        return nil
    }
    
    static func save(data: Data, to path: String) {
        
        let paths = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)
        let desktopPath = paths.first
        guard let url = URL(fileURLWithPath: desktopPath) else {
            return print("Could not obtain the desktop path")
        }
        
        do {
            try data.write(to: url)
        } catch {
            print("Could not write file to desktop")
        }
        
    }
    
}
