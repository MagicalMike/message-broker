//
//  Extensions.swift
//  Server
//
//  Created by Mihai Petrenco on 10/31/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import SwiftSocket

extension NSColor {
    
    convenience init(random: Bool) {

        let red = CGFloat((arc4random_uniform(100) + 100)) / 255.0
        let green = CGFloat((arc4random_uniform(100) + 100)) / 255.0
        let blue = CGFloat((arc4random_uniform(100) + 100)) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
}
