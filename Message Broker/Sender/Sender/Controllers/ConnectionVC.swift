//
//  ViewController.swift
//  Sender
//
//  Created by Mihai Petrenco on 11/2/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Cocoa
import SwiftSocket

class ConnectionVC: NSViewController {

    //MARK: - Outlet declarations
    @IBOutlet weak var ipTextfield: CustomTextField!
    @IBOutlet weak var portTextfield: CustomTextField!
    @IBOutlet weak var connectionLabel: NSTextField!
    

    //MARK: - Variable declarations
    var client: TCPClient?
    
    //MARK: - View lifecycle
    override func viewDidAppear() {
        self.setupWindow()
    }

    
    //MARK: - User Actions
    @IBAction func connectBtnPressed(_ sender: Any) {
        
        guard let address = validate(address: ipTextfield.stringValue) else {
            return notifyLabel(of: "Invalid IP address.")
        }
        
        guard let port = Int32(portTextfield.stringValue) else {
            return notifyLabel(of: "Invalid port number.")
        }
        
        client = TCPClient(address: address, port: port)
        
        switch client!.connect(timeout: 10) {
        case .success:
            let identifier = NSStoryboardSegue.Identifier(rawValue: "MessagingVC")
            performSegue(withIdentifier: identifier, sender: self)
        case .failure(_):
            notifyLabel(of: "Connection timeout!")
        }
    }
    
    //MARK: - Segue preparation
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        let destination = segue.destinationController as! MessagingVC
        destination.previousVC = self
        destination.client = self.client
    }
    
    //MARK: - UI-related functions
    func setupWindow() {
        let window = self.view.window
        window?.backgroundColor = #colorLiteral(red: 0.2596075237, green: 0.2981915474, blue: 0.3495857716, alpha: 1)
        window?.isMovableByWindowBackground = true
        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .hidden
        window?.minSize = NSSize(width: 292, height: 424)
        window?.maxSize = NSSize(width: 292, height: 424)
    }
    
    func notifyLabel(of error: String) {
        connectionLabel.stringValue = error
        connectionLabel.isHidden = false
    }
    
    func validate(address: String) -> String? {
        if address.count < 7 || address.count > 15 { //0.0.0.0 - 255.255.255.255
            return nil                             //I know it's stupid, i'll add a real check later
        }
        return address
    }
    
    //
    
}

