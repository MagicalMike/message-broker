//
//  AppDelegate.swift
//  Server
//
//  Created by Mihai Petrenco on 11/4/17.
//  Copyright © 2017 Limitless. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationWillTerminate(_ aNotification: Notification) {
        QueueStore.save()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

