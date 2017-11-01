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
    
}
