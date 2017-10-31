//
//  MessageStore.swift
//  Receiver
//
//  Created by Mihai Petrenco on 10/31/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class MessageStore {
    
    private(set) static var messages = [(address: NSMutableAttributedString,content: String)]()
    
    static func addMessage(by client: String, with content: String) {
        let attributedString = NSMutableAttributedString(string: client)
        let range = (client as NSString).range(of: client)
        attributedString.addAttribute(.foregroundColor, value: NSColor.red, range: range)
        
        let message = (attributedString,content)
        messages.append(message)
    }
    
    public static func reset() {
        self.messages.removeAll()
    }
    
}
