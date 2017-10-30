//
//  CommandButton.swift
//  Sender
//
//  Created by Mihai Petrenco on 10/30/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class CommandButton: NSPopUpButton {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        populate()
    }
    
    func populate() {
        self.addItem(withTitle: Command.send.rawValue)
        self.addItem(withTitle: Command.display.rawValue)
    }
    
}
