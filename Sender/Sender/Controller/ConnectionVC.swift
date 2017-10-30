//
//  ConnectionVC.swift
//  Sender
//
//  Created by Mihai Petrenco on 10/30/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa
import SwiftSocket

class ConnectionVC: NSViewController {
    
    @IBOutlet weak var ipTextfield: CustomTextField!
    @IBOutlet weak var portTextfield: CustomTextField!
    @IBOutlet weak var connectionLabel: NSTextField!
    
    private var client: TCPClient?
    
    @IBAction func connectBtnPressed(_ sender: Any) {
        
        let address = ipTextfield.stringValue
        let port = portTextfield.stringValue
        
        if address == "" || port == "" {
            connectionLabel.stringValue = "Please enter both fields."
            connectionLabel.isHidden = false
            return
        }
        
        guard let portValue = Int32(port) else {
            connectionLabel.stringValue = "Invalid port number."
            connectionLabel.isHidden = false
            return
        }
        
        connect(address: address, port: portValue)
    }
    
    func connect(address: String, port: Int32) {
        client = TCPClient(address: address, port: port)
        
        switch client!.connect(timeout: 10) {
        case .success:
            performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "Connect"), sender: self)
        case .failure(_):
            connectionLabel.stringValue = "Connection timeout!"
            connectionLabel.isHidden = false
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        let destination = segue.destinationController as! MessagingVC
        destination.setClient(client: self.client!)
    }
    
}
