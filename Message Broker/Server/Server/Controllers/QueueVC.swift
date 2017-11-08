//
//  QueueVC.swift
//  Server
//
//  Created by Mihai Petrenco on 11/6/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class QueueVC: NSViewController {
    
    //MARK: - Outlet declarations
    @IBOutlet weak var queueTable: NSTableView!
    
    //MARK: - Variable declarations
    let queueDeleagete = SelectedDelegate()
    let queueDataSource = SelectedDataSource()
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        queueTable.delegate = queueDeleagete
        queueTable.dataSource = queueDataSource
        DispatchQueue.main.async {
            self.queueTable.reloadData()
        }
    }
    
    override func viewDidAppear() {
        DispatchQueue.main.async {
            self.queueTable.reloadData()
        }
        
    }
    
}
