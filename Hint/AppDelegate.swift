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
    
    var textSource: TextSource!
    var autoLaunch: Bool = false
    
    var notificationText = NotificationText.hints
    var notificationSound = NotificationSound.silent
    var notificationTimer: Timer?
    var notificationInterval: Int = 300
    
    var pauseTimer: Timer?
    var pauseInterval: Int = 0
    var paused: Bool = false
    
    var sound: NSSound?
    
    /* Lifecycle */
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        statusItem.button?.image = NSImage(named: "MenuBarIcon")
        statusItem.menu = statusMenu!
        
        loadSettings()
        loadText(text: notificationText)
        schedule(seconds: notificationInterval)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) { }
    
    /* Actions */
    
    @IBAction func actionAbout(_ sender: NSMenuItem) {
        NSApplication.shared().activate(ignoringOtherApps: true)
        aboutPanel.orderFront(self)
        aboutPanel.makeKey()
    }
    
    @IBAction func actionChangeInterval(_ sender: NSMenuItem) {
        schedule(seconds: sender.tag)
    }
    
    @IBAction func actionPause(_ sender: NSMenuItem) {
        if sender.tag > 0 {
            pause(seconds: sender.tag)
        } else {
            pause()
        }
    }
    
    @IBAction func actionResume(_ sender: NSMenuItem) {
        resume()
    }
    
    @IBAction func actionChangeText(_ sender: NSMenuItem) {
        loadText(text: notificationTextOptions[sender.tag]!)
    }
    
    @IBAction func actionChangeSound(_ sender: NSMenuItem) {
        loadSound(sound: notificationSoundTags[sender.tag]!)
    }
    
    @IBAction func actionChangeAutoLaunch(_ sender: NSMenuItem) {
        
        autoLaunch = !autoLaunch
        
        let appBundleIdentifier = "com.crsmithdev.HintLauncher"
        var helperURL = Bundle.main.bundleURL
        helperURL.appendPathComponent("Contents/Library/LoginItems/HintLauncher.app")
        
        if SMLoginItemSetEnabled(appBundleIdentifier as CFString, autoLaunch) {
            if autoLaunch {
                NSLog("Successfully add login item.")
            } else {
                NSLog("Successfully remove login item.")
            }
            
        } else {
            NSLog("Failed to add login item.")
        }
    }
    
    @IBAction func actionQuit(_ sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }
    
    /* Menu */
    
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        
        if menuItem.action == #selector(self.actionChangeInterval) {
            menuItem.state = menuItem.tag == notificationInterval ? 1 : 0
            return true
        }
        
        if menuItem.action == #selector(self.actionPause) {
            menuItem.state = paused && menuItem.tag == pauseInterval ? 1 : 0
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
        
        if menuItem.action == #selector(self.actionResume) {
            return paused
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
        notificationInterval = 15 //int > 0 ? int : Constants.defaultNotificationInterval
        
        let str2 = UserDefaults().string(forKey: Constants.notificationSoundKey) ??
            Constants.defaultNotificationSound
        notificationSound = NotificationSound.init(rawValue: str2)!
        loadSound(sound: notificationSound)
        
        statusItem.button?.image = NSImage(named: "MenuBarIcon")
        statusItem.menu = statusMenu!
    }
    
    func schedule(seconds: Int) {
        
        notificationInterval = Int(seconds)
        UserDefaults().set(notificationInterval, forKey: Constants.notificationIntervalKey)
        
        notificationTimer?.invalidate()
        notificationTimer = Timer.scheduledTimer(
            timeInterval: TimeInterval(seconds),
            target: self,
            selector: #selector(self.notify),
            userInfo: nil,
            repeats: true
        )
        
        DLog("scheduled for \(seconds)s")
    }
    
    func pause() {
        
        pauseInterval = 0
        pauseTimer?.invalidate()
        paused = true
    }
    
    func pause(seconds: Int) {
        
        paused = true
        pauseInterval = seconds
        
        pauseTimer?.invalidate()
        pauseTimer = Timer.scheduledTimer(
            timeInterval: TimeInterval(seconds),
            target: self,
            selector: #selector(self.resume),
            userInfo: nil,
            repeats: false
        )
        
        DLog("paused for \(pauseInterval)s")
    }
    
    func resume() {
        pauseInterval = 0
        paused = false
        DLog("resumed")
    }
    
    func notify() {
        
        if paused {
            DLog("skipping notification, paused")
            return
        }
        
        let text = textSource.next()
        Notifier.shared.notify(text: text)
        playSound()
        
        DLog("notified '\(text)'")
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
    
    func playSound() {
        
        if notificationSound == .silent {
            return
        }
        
        sound!.play()
    }
}






