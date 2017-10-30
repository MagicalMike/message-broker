//
//  CustomTextField.swift
//  Sender
//
//  Created by Mihai Petrenco on 10/30/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

@IBDesignable
class CustomTextField: NSTextField {
    
    override func prepareForInterfaceBuilder() {
        bezelStyle = .roundedBezel
        wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        bezelStyle = .roundedBezel
        drawsBackground = false
        wantsLayer = true
    }
    
}
