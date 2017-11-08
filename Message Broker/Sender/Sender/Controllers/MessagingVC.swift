//
//  MessagingVC.swift
//  Sender
//
//  Created by Mihai Petrenco on 11/2/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Cocoa
import SwiftSocket

class MessagingVC: NSViewController {
    
    //MARK: - Outlet declarations
    @IBOutlet weak var activityTable: NSTableView!
    @IBOutlet weak var inputTextfield: CustomTextField!
    @IBOutlet weak var putButton: CustomButton!
    @IBOutlet weak var countButton: CustomButton!
    @IBOutlet weak var removeButton: CustomButton!
    @IBOutlet weak var errorLabel: NSTextField!
    
    //MARK: - Variable declarations
    let activityDelegate = ActivityDelegate()
    let activityDataSource = ActivityDataSource()
    private var selectedCommand = Command.none
    private var listening = true
    var previousVC: ConnectionVC!
    var client:TCPClient?
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        activityTable.delegate = activityDelegate
        activityTable.dataSource = activityDataSource
        previousVC!.dismiss(self)
        previousVC.view.window?.close()
        
        DispatchQueue.global().async {
            while self.listening {
                self.listen()
            }
        }
    }
    
    override func viewDidAppear() {
        let window = self.view.window
        window?.backgroundColor = #colorLiteral(red: 0.2596075237, green: 0.2981915474, blue: 0.3495857716, alpha: 1)
        window?.isMovableByWindowBackground = true
        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .hidden
    }
    
    //MARK: - User actions
    @IBAction func queueBtnPressed(_ sender: Any) {
        let identifier = NSStoryboardSegue.Identifier.init(rawValue: "QueueVC")
        performSegue(withIdentifier: identifier, sender: self)
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        let input = inputTextfield.stringValue
        
        if selectedCommand == .put && !isValidString(for: input) {
            errorLabel.stringValue = "Input text is not valid!"
            errorLabel.isHidden = false
            return
        }
        
        if selectedCommand == .none {
            errorLabel.stringValue = "No command has been selected!"
            errorLabel.isHidden = false
            return
        }
        
        inputTextfield.stringValue = ""
        ActivityStore.addActivity(command: selectedCommand, contents: input)
        activityTable.reloadData()
        errorLabel.isHidden = true
        
        let command = selectedCommand.rawValue
        let queues = QueueStore.queues
        
        let json = Serializer.generate(command: command, to: queues, with: input)
        guard let data = Serializer.toData(from: json) else {
            print("Error while generating Data object")
            return
        }
        let response = client?.send(data: data)
        
        switch response {
        case .some(_):
            //Congratulations
            break
        case .none:
            notifyActivity(of: .error, containing: "Could not send data!")
        }
        
    }
    
    //MARK: - Client functionalities
    func listen() {
        if let input = self.client?.read(1024) {
            let data = Data(bytes: input)
            guard let json = Serializer.toJSON(from: data) else {
                self.notifyActivity(of: .error, containing: "Could not read server data!")
                return
            }
            decompose(json: json)
        }
    }
    
    func decompose(json: [String:Any]) {
        guard let command = json["Command"] as? String else {
            self.notifyActivity(of: .error, containing: "JSON format obtained is corrupted!")
            return
        }
        
        guard let contents = json["Contents"] as? String else {
            self.notifyActivity(of: .error, containing: "JSON format obtained is corrupted!")
            return
        }
        self.notifyActivity(of: getCommand(from: command), containing: contents)
    }
    
    func getCommand(from raw: String) -> Command {
        switch raw {
        case "RESPONSE":
            return .response
        default:
            return .error
        }
    }
    
    @IBAction func putBtnPressed(_ sender: Any) {
        selectedCommand = .put
        inputTextfield.isEnabled = true
        disablePopups(except: putButton)
    }
    
    @IBAction func countBtnPressed(_ sender: Any) {
        selectedCommand = .count
        inputTextfield.isEnabled = false
        inputTextfield.stringValue = ""
        disablePopups(except: countButton)
    }
    
    @IBAction func removeBtnPressed(_ sender: Any) {
        selectedCommand = .remove
        inputTextfield.isEnabled = false
        inputTextfield.stringValue = ""
        disablePopups(except: removeButton)
    }
    
    //MARK: UI-related
    func isValidString(for string: String) -> Bool {
        if string.count > 0 && string.first != " " {
            return true
        }
        return false
    }
    
    func disablePopups(except button: CustomButton) {
        putButton.state = .off
        countButton.state = .off
        removeButton.state = .off
        button.state = .on
    }
    
    func notifyActivity(of command: Command, containing content:String) {
        ActivityStore.addActivity(command: command, contents: content)
        DispatchQueue.main.async {
            self.activityTable.reloadData()
        }
    }
    
    
}
