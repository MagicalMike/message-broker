//
//  ContentStore.swift
//  Server
//
//  Created by Mihai Petrenco on 10/31/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class ContentStore {
    
    private(set) static var activities = [(address: NSMutableAttributedString,content: String)]()
    
    static func addActivity(by client: String, with content: String) {
        
        let attributedString = NSMutableAttributedString(string: client)
        let range = (client as NSString).range(of: client)
        attributedString.addAttribute(.foregroundColor, value: NSColor.red, range: range)
        
        let activity = (attributedString,content)
        activities.append(activity)
    }
    
}
