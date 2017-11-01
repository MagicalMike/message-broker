//
//  ViewController.swift
//  Server
//
//  Created by Mihai Petrenco on 10/30/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Cocoa
import SwiftSocket

class ConnectionVC: NSViewController {

    @IBOutlet weak var ipTextfield: NSTextField!
    @IBOutlet weak var portTextfield: NSTextField!
    @IBOutlet weak var connectionLabel: NSTextField!
    
    private var server: TCPServer?
    
    override func viewDidAppear() {
        self.view.window?.title = "Server"
        self.view.window?.minSize = NSSize(width: 214, height: 283)
        self.view.window?.maxSize = NSSize(width: 214, height: 283)
    }
    
    @IBAction func connectBtnPressed(_ sender: Any) {
        
        let address = ipTextfield.stringValue
        let port = portTextfield.stringValue
        
        if address == "" || port == "" {
            connectionLabel.isHidden = false
            connectionLabel.stringValue = "Please enter both fields."
            return
        }
        
        guard let portValue = Int32(port) else {
            connectionLabel.isHidden = false
            connectionLabel.stringValue = "Invalid port value."
            return
        }
        
        connect(address: address, port: portValue)
        
    }
    
    func connect(address: String, port: Int32) {
        server = TCPServer(address: address, port: port)
        
        switch server!.listen() {
        case .success:
            let identifier = NSStoryboardSegue.Identifier("Connect")
            performSegue(withIdentifier: identifier, sender: self)
            
        case .failure(_):
            connectionLabel.isHidden = false
            connectionLabel.stringValue = "Could not connect!"
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        let destination = segue.destinationController as! ListeningVC
        destination.setServer(server: self.server!)
    }
    
}

