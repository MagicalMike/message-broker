//
//  ContentStore.swift
//  Server
//
//  Created by Mihai Petrenco on 10/31/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class ActivityStore {
    
    private(set) static var activities = [(address: NSMutableAttributedString,content: String)]()
    
    static func addActivity(by client: String, having color:NSColor, with content: String) {
        
        let attributedString = NSMutableAttributedString(string: client)
        let range = (client as NSString).range(of: client)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        
        let activity = (attributedString,content)
        activities.append(activity)
    }
    
}
