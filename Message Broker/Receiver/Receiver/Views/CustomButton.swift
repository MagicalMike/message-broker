//
//  CustomButton.swift
//  Sender
//
//  Created by Mihai Petrenco on 11/3/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class CustomButton: NSButton {
    
    override func awakeFromNib() {
        self.wantsLayer = true
        let attributedString = NSMutableAttributedString(string: self.title)
        let range = (title as NSString).range(of: title)
        attributedString.addAttribute(.foregroundColor, value: NSColor.white, range: range)
        let font = NSFont(name: "Comfortaa", size: 16)
        attributedString.addAttribute(.font, value: font!, range: range)
        self.attributedTitle = attributedString
    }
    
}
