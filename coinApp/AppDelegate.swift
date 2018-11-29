//
//  AppDelegate.swift
//  coinApp
//
//  Created by User on 30/08/2018.
//  Copyright © 2018 User. All rights reserved.
//

import Cocoa
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
     let coinAPI = CoinAPI()
    
    
    @IBAction func updateClicked(_ sender: Any) {
 let coin2 = CoinAPI()
        statusItem.title = coin2.Display()
    }
    
    @IBAction func XRPclicked(_ sender: Any) {
        let coin3 = CoinAPI()
        statusItem.title = coin3.DisplayXRP()
        
    }
    @IBAction func click(_ sender: Any) {
       NSApplication.shared.terminate(self)
    }
    
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
 
                statusItem.title = coinAPI.Display()
                
                statusItem.menu = statusMenu

        
        NSApp.setActivationPolicy(.prohibited)
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

