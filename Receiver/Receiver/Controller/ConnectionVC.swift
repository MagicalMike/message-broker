//
//  ViewController.swift
//  Receiver
//
//  Created by Mihai Petrenco on 10/31/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Cocoa
import SwiftSocket

class ConnectionVC: NSViewController {

    @IBOutlet weak var ipTextfield: NSTextField!
    @IBOutlet weak var portTextfield: NSTextField!
    @IBOutlet weak var connectionLabel: NSTextField!
    
    private(set) var client: TCPClient?
    
    @IBAction func connectBtnPressed(_ sender: Any) {
        
        let address = ipTextfield.stringValue
        let port = portTextfield.stringValue
        
        guard let portValue = Int32(port) else {
            connectionLabel.stringValue = "Invalid port number."
            connectionLabel.isHidden = false
            return
        }
        
        if address != "" {
            self.connect(address: address, port: portValue)
        } else {
            connectionLabel.stringValue = "Enter both fields."
            connectionLabel.isHidden = false
        }
    }
    
    func connect(address: String, port: Int32) {
        client = TCPClient(address: address, port: port)
        
        switch client!.connect(timeout: 10) {
        case .success:
            performSegue(withIdentifier: .init("ReceiverVC"), sender: self)
        case .failure(_):
            connectionLabel.stringValue = "Connection timeout!"
            connectionLabel.isHidden = false
        }
        
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        let destination = segue.destinationController as! ReceiverVC
        destination.setClient(client: self.client!)
    }
    
}

