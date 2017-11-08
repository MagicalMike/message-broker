//
//  CustomTextfield.swift
//  Sender
//
//  Created by Mihai Petrenco on 11/2/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class CustomTextField: NSTextField {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.wantsLayer = true
    }
    
    override func awakeFromNib() {
        self.isBordered = false
        self.backgroundColor = #colorLiteral(red: 0.1964412145, green: 0.2126911957, blue: 0.236298382, alpha: 1)
        self.layer?.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.layer?.cornerRadius = 5.0
        self.frame.size = NSSize(width: self.frame.width, height: 30)
        
        self.font = NSFont(name: "Comfortaa", size: 20)
        
    }
    
    
}
