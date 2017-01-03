//
//  AppDelegate.swift
//  HintLauncher
//
//  Created by Christopher Smith on 12/31/16.
//  Copyright © 2016 Chris Smith. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
    
        let applications = NSWorkspace.shared().runningApplications
        let running = applications.filter({$0.bundleIdentifier == "com.crsmithdev.Hint"}).count > 0
        
        if !running {
            
            let launcherPath = Bundle.main.bundlePath as NSString
            var components = launcherPath.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append("Hint")
            
            let appPath = NSString.path(withComponents: components)
            NSWorkspace.shared().launchApplication(appPath)
        }

        NSApp.terminate(nil)
    }
}
