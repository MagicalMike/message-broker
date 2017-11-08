//
//  ActivityStore.swift
//  Sender
//
//  Created by Mihai Petrenco on 11/2/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class ActivityStore {
    
    private(set) static var activities = [NSAttributedString]()
    
    public static func addActivity(command: Command, contents: String) {
        guard let validEntry = process(command: command, contents: contents) else {
            return
        }
        activities.append(validEntry)
    }
    
    public static func clearActivities() {
        activities.removeAll()
    }
    
    private static func process(command: Command, contents: String) -> NSAttributedString? {
        
        var attributedString: NSMutableAttributedString?
        var input = ""
        var color = NSColor()
        
        switch command {
        case .get:
            input = "Trying to get message from queues..."
            color = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case .count:
            input = "Requesting queue count from server..."
            color = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case .subscribe:
            input = "Attempting to subscribe to queues..."
            color = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        case .response:
            input = contents
            color = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case .error:
            input = contents
            color = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        case .none:
            return nil
        }

        let range = (input as NSString).range(of: input)
        attributedString = NSMutableAttributedString(string: input)
        attributedString?.addAttribute(.foregroundColor, value: color, range: range)
        return attributedString
    }
}
