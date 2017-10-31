//
//  MessageStore.swift
//  Sender
//
//  Created by Mihai Petrenco on 10/30/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class MessageStore {
    
    private(set) static var messages = [NSAttributedString]()
    
    public static func addMessage(command: String, message: String) {
        
        var entry = ""
        var range = NSRange()
        var color = NSColor.black
        
        if command == "Send" {
            entry += "Message sent: "
            range = (entry as NSString).range(of: entry)
            entry += "\(message)"
            color = .red
        }
        
        if command == "Display" {
            entry += "Asking for message publishing."
            range = (entry as NSString).range(of: entry)
            color = .blue
        }
        
        let attributedString = NSMutableAttributedString(string: entry)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        
        messages.append(attributedString)
    }
    
    public static func addError(with message: String) {
        let range = (message as NSString).range(of: message)
        let color = NSColor.red
        let attributedString = NSMutableAttributedString(string: message)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        messages.append(attributedString)
    }
    
    public static func reset() {
        self.messages.removeAll()
    }
}
