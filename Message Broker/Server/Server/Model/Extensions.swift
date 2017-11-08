//
//  Extensions.swift
//  Server
//
//  Created by Mihai Petrenco on 11/6/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Cocoa

extension NSColor {
    
    //Generate a random color between a lower and upper limit
    public convenience init(from min: UInt32, with offset: UInt32) {
        let red = CGFloat(arc4random_uniform(offset) + min) / 255.0
        let blue = CGFloat(arc4random_uniform(offset) + min) / 255.0
        let green = CGFloat(arc4random_uniform(offset) + min) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
}
