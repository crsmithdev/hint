//
//  AppDelegate.swift
//  Reminder
//
//  Created by Christopher Smith on 12/18/16.
//  Copyright © 2016 Chris Smith. All rights reserved.
//

import Foundation
import Cocoa
import ServiceManagement


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet var aboutPanel: NSPanel!
    @IBOutlet var statusMenu: NSMenu!
    @IBOutlet var debugMenu: NSMenuItem!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    
    let scheduler = Scheduler()

    var messageType = MessageType.hints
    var messages: MessageIterator!

    var interval: Int = 300  // TODO no default here
    var pauseInterval: Int = 0 // TODO no default here
    
    var soundType = SoundType.silent
    var sound: NSSound?
    
    var autoLaunch: Bool = false
    
    /* Lifecycle */
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        statusItem.button?.image = NSImage(named: "MenuBarIcon")
        statusItem.menu = statusMenu!
        
        #if DEBUG
            debugMenu.isHidden = false
        #endif
        
        loadSettings()
        loadText(messageType)
        loadSound(soundType)
        scheduler.schedule(interval, block: self.notify)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) { }
    
    /* Actions */
    
    @IBAction func actionDebugNotifyNow(_ sender: NSMenuItem) {
        notify()
    }
    
    @IBAction func actionDebugRapidFire(_ sender: NSMenuItem) {
        scheduler.schedule(Constants.intervalRapid, block: notify)
    }
    
    @IBAction func actionAbout(_ sender: NSMenuItem) {
        NSApplication.shared().activate(ignoringOtherApps: true)
        aboutPanel.makeKeyAndOrderFront(self)
    }
    
    @IBAction func actionChangeInterval(_ sender: NSMenuItem) {
        changeInterval(sender.tag)
    }
    
    @IBAction func actionPause(_ sender: NSMenuItem) {
        pauseInterval = sender.tag
        scheduler.pause(sender.tag)
    }
    
    @IBAction func actionResume(_ sender: NSMenuItem) {
        pauseInterval = 0
        scheduler.resume()
    }
    
    @IBAction func actionChangeText(_ sender: NSMenuItem) {
        loadText(MessageType(tag: sender.tag)!)  // TODO error handling
    }
    
    @IBAction func actionChangeSound(_ sender: NSMenuItem) {
        loadSound(SoundType(tag: sender.tag)!)  // TODO error handling
    }
    
    @IBAction func actionChangeAutoLaunch(_ sender: NSMenuItem) {
        toggleAutoLaunch()
    }
    
    @IBAction func actionQuit(_ sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }
    
    /* Menu */
    
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        
        if menuItem.action == #selector(self.actionDebugRapidFire) {
            menuItem.state = scheduler.interval == Constants.intervalRapid ? 1 : 0
            
        } else if menuItem.action == #selector(self.actionChangeInterval) {
            menuItem.state = menuItem.tag == scheduler.interval ? 1 : 0
            
        } else if menuItem.action == #selector(self.actionChangeText) {
            menuItem.state = messageType.tag() == menuItem.tag ? 1 : 0
            
        } else if menuItem.action == #selector(self.actionChangeSound) {
            menuItem.state = soundType.tag() == menuItem.tag ? 1 : 0
            
        } else if menuItem.action == #selector(self.actionChangeAutoLaunch) {
            menuItem.state = autoLaunch ? 1 : 0
            
        } else if menuItem.action == #selector(self.actionPause) {
            menuItem.state = scheduler.paused && menuItem.tag == pauseInterval ? 1 : 0
            
        } else if menuItem.action == #selector(self.actionResume) {
            return scheduler.paused
        }
        
        return true
    }
    
    /* Logic */
    
    func loadSettings() {
        
        let defaults = UserDefaults()
        
        let intervalValue = defaults.integer(forKey: Constants.intervalKey)
        interval = intervalValue > 0 ? intervalValue : Constants.intervalDefault
        
        messageType = MessageType(saved: defaults.string(forKey: Constants.messageTypeKey))
        soundType = SoundType(saved: defaults.string(forKey: Constants.soundTypeKey))
        autoLaunch = UserDefaults().bool(forKey: Constants.autoLaunchKey)
    }
    
    func changeInterval(_ seconds: Int) {
        interval = seconds
        UserDefaults().set(interval, forKey: Constants.intervalKey)
        scheduler.schedule(interval, block: self.notify)
    }
    
    func toggleAutoLaunch() {
        autoLaunch = !autoLaunch
        SMLoginItemSetEnabled(Constants.launcherBundleIdentifier as CFString, autoLaunch)
        UserDefaults().set(autoLaunch, forKey: Constants.autoLaunchKey)
        DLog("set autolaunch: \(autoLaunch)")
    }
    
    func loadText(_ type: MessageType) {
        messageType = type
        UserDefaults().set(messageType.rawValue, forKey: Constants.messageTypeKey)
        messages = try? MessageIterator.fromFile(name: messageType.rawValue) // TODO error handling
    }
    
    func loadSound(_ type: SoundType) {
        soundType = type
        UserDefaults().set(soundType.rawValue, forKey: Constants.soundTypeKey)
        
        switch soundType {
        case .silent:
            sound = nil
        default:
            // TODO error handling
            let data = NSDataAsset(name: "Sounds/\(soundType.rawValue)")!
            self.sound = NSSound(data: data.data)
        }
        
        DLog("loaded type: \(type), sound: \(sound)")
    }
    
    func notify() {
        Notifier.shared.send(messages.next(), sound: sound)
    }
}
