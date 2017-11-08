//
//  QueueViewController.swift
//  Sender
//
//  Created by Mihai Petrenco on 11/3/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Foundation
import Cocoa

class QueueVC: NSViewController {
    
    //MARK: - Outlet declarations
    @IBOutlet weak var queueTable: NSTableView!
    @IBOutlet weak var inputTextfield: CustomTextField!
    
    //MARK: - Variable declarations
    private var queueDelegate = QueueDelegate()
    private var queueDataSource = QueueDataSource()
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        queueTable.delegate = queueDelegate
        queueTable.dataSource = queueDataSource
    }
    
    //MARK: - User actions
    @IBAction func addBtnPressed(_ sender: Any) {
        let input = inputTextfield.stringValue
        if input.count > 0 && input.first != " " {
            QueueStore.addQueue(named: input)
            queueTable.reloadData()
            inputTextfield.stringValue = ""
        }
    }
    
    @IBAction func removeBtnPressed(_ sender: Any) {
        QueueStore.remove()
        queueTable.reloadData()
    }
    
}
