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
    
    //MARK: - Variable declarations
    private(set) static var activities = [(address: NSMutableAttributedString,content: String)]()
    
    //MARK: - Function implementations
    static func addActivity(by client: String, having color: NSColor, with content: String) {
        
        let attributedString = NSMutableAttributedString(string: client)
        let range = (client as NSString).range(of: client)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        
        let activity = (attributedString,content)
        activities.append(activity)
    }
    
}
