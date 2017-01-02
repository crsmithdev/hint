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

enum NotificationText: String {
    case hints = "Hints"
}

let notificationTextOptions = [
    0: NotificationText.hints
]

enum NotificationSound: String {
    case silent = ""
    case singingBowlLow = "SingingBowlLow"
    case singingBowlHigh = "SingingBowlHigh"
}

let notificationSoundTags = [
    0: NotificationSound.silent,
    1: NotificationSound.singingBowlLow,
    2: NotificationSound.singingBowlHigh,
]

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet var aboutPanel: NSPanel!
    @IBOutlet var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    
    let scheduler = Scheduler()
    var textSource: TextSource!
    var autoLaunch: Bool = false
    
    
    
    var notificationText = NotificationText.hints
    var notificationSound = NotificationSound.silent
    var notificationInterval: Int = 300
    
    var pauseInterval: Int = 0
    
    var sound: NSSound?
    
    /* Lifecycle */
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        statusItem.button?.image = NSImage(named: "MenuBarIcon")
        statusItem.menu = statusMenu!
        
        loadSettings()
        loadText(text: notificationText)
        
        scheduler.schedule(notificationInterval, block: self.notify)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) { }
    
    /* Actions */
    
    @IBAction func actionAbout(_ sender: NSMenuItem) {
        NSApplication.shared().activate(ignoringOtherApps: true)
        aboutPanel.orderFront(self)
        aboutPanel.makeKey()
    }
    
    @IBAction func actionChangeInterval(_ sender: NSMenuItem) {
        scheduler.schedule(sender.tag, block: self.notify)
    }
    
    @IBAction func actionPause(_ sender: NSMenuItem) {
        scheduler.pause(sender.tag)
    }
    
    @IBAction func actionResume(_ sender: NSMenuItem) {
        scheduler.resume()
    }
    
    @IBAction func actionChangeText(_ sender: NSMenuItem) {
        loadText(text: notificationTextOptions[sender.tag]!)
    }
    
    @IBAction func actionChangeSound(_ sender: NSMenuItem) {
        loadSound(sound: notificationSoundTags[sender.tag]!)
    }
    
    @IBAction func actionChangeAutoLaunch(_ sender: NSMenuItem) {
        
        autoLaunch = !autoLaunch
        SMLoginItemSetEnabled(Constants.launcherBundleIdentifier as CFString, autoLaunch)
        UserDefaults().set(autoLaunch, forKey: Constants.autoLaunchKey)
        
        DLog("Set autolaunch: \(autoLaunch)")
    }
    
    @IBAction func actionQuit(_ sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }
    
    /* Menu */
    
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        
        if menuItem.action == #selector(self.actionChangeInterval) {
            menuItem.state = menuItem.tag == scheduler.interval ? 1 : 0
            return true
        }
        
        if menuItem.action == #selector(self.actionChangeText) {
            menuItem.state = notificationTextOptions[menuItem.tag] == notificationText ? 1 : 0
            return true
        }
        
        if menuItem.action == #selector(self.actionChangeSound) {
            menuItem.state = notificationSoundTags[menuItem.tag] == notificationSound ? 1 : 0
            return true
        }
        
        if menuItem.action == #selector(self.actionPause) {
            menuItem.state = scheduler.paused && menuItem.tag == pauseInterval ? 1 : 0
            return true
        }
        
        if menuItem.action == #selector(self.actionResume) {
            return scheduler.paused
        }
        
        if menuItem.action == #selector(self.actionChangeAutoLaunch) {
            menuItem.state = autoLaunch ? 1 : 0
            return true
        }
        
        return true
    }
    
    /* Logic */
    
    func loadSettings() {
        
        let str = UserDefaults().string(forKey: Constants.notificationTextKey) ??
            Constants.defaultNotificationText
        notificationText = NotificationText.init(rawValue: str)!
        
        let int = UserDefaults().integer(forKey: Constants.notificationIntervalKey)
        notificationInterval = int > 0 ? int : Constants.defaultNotificationInterval
        
        let str2 = UserDefaults().string(forKey: Constants.notificationSoundKey) ??
            Constants.defaultNotificationSound
        notificationSound = NotificationSound.init(rawValue: str2)!
        loadSound(sound: notificationSound)
        
        autoLaunch = UserDefaults().bool(forKey: Constants.autoLaunchKey)
    }
    
    func notify() {
        Notifier.shared.send(textSource.next(), sound: sound)
    }
    
    func loadText(text: NotificationText) {
        // TODO error handling
        notificationText = text
        let path = Bundle.main.path(forResource: text.rawValue, ofType: "txt")!
        textSource = try? TextSource.fromFile(path: path)
    }
    
    func loadSound(sound: NotificationSound) {
        
        notificationSound = sound
        UserDefaults().set(notificationSound.rawValue, forKey: Constants.notificationSoundKey)
        
        if sound == .silent {
            self.sound = nil
        } else {
            let data = NSDataAsset(name: "Sounds/\(notificationSound.rawValue)")!
            self.sound = NSSound(data: data.data)
        }
    }
}
