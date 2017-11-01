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
    
    private(set) static var messages = [NSMutableAttributedString]()
    
    public static func addMessage(command: Command, message: String) {
        
        var entry = ""
        var range = NSRange()
        var color = NSColor.black
        
        if command == .get {
            entry += "Requesting message from server..."
            range = (entry as NSString).range(of: entry)
            color = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        
        if command == .subscribe {
            entry += "Subscribing to: "
            range = (entry as NSString).range(of: entry)
            color = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
            entry += "\(message)"
        }
        
        if command == .count {
            entry += "Requesting queue size..."
            range = (entry as NSString).range(of: entry)
            color = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }
        
        if command == .error {
            entry += message
            range = (entry as NSString).range(of: entry)
            color = #colorLiteral(red: 0.8470613896, green: 0.007929981659, blue: 0, alpha: 1)
        }
        
        if command == .response {
            entry += message
            range = (entry as NSString).range(of: entry)
            color = #colorLiteral(red: 0.2269507461, green: 0.8078431487, blue: 0.07554045882, alpha: 1)
        }
        
        let attributedString = NSMutableAttributedString(string: entry)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        
        messages.append(attributedString)
    }
    
    public static func addError(content: String) {
        let range = (content as NSString).range(of: content)
        let color = NSColor.red
        
        let attributedString = NSMutableAttributedString(string: content)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)

        messages.append(attributedString)
    }
    
    public static func reset() {
        self.messages.removeAll()
    }
    
}
