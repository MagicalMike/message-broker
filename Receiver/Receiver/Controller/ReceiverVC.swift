//
//  ReceiverVC.swift
//  Receiver
//
//  Created by Mihai Petrenco on 10/31/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa
import SwiftSocket

class ReceiverVC: NSViewController {
    
    @IBOutlet weak var messageTable: NSTableView!
    
    private(set) var client: TCPClient?
    
    override func viewDidLoad() {
        MessageStore.reset()
        messageTable.reloadData()
        receive(client: client!)
    }
    
    func receive(client: TCPClient) {
        DispatchQueue.global().async {
            while(true) {
                if let data = client.read(1024) {
                    print(data)
                }
            }
            
        }
    }
    
    func setClient(client: TCPClient) {
        self.client = client
    }
}
