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
        
        @IBOutlet var statusMenu: NSMenu!
        @IBOutlet var debugMenu: NSMenuItem!
        
        var aboutWindowController: NSWindowController!
        var notificationWindowController: NotificationWindowController!
        
        let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
        let settings = Settings(UserDefaults())
        let scheduler = Scheduler()
        
        var quotes: QuoteCollection!
        var sound: Sound?
        
        /* Lifecycle */
        
        func applicationDidFinishLaunching(_ aNotification: Notification) {
            
            statusItem.button?.image = NSImage(named: "MenuBarIcon")
            statusItem.menu = statusMenu!
            
            let sb = NSStoryboard(name: "Main", bundle: nil)
            aboutWindowController = sb.instantiateController(withIdentifier: "AboutWindow") as! NSWindowController
            notificationWindowController = sb.instantiateController(withIdentifier: "NotificationWindow") as! NotificationWindowController
            
            #if DEBUG
                debugMenu.isHidden = false
            #endif
            
            loadText(settings.quoteType)
            loadSound(settings.soundType)
            
            scheduler.schedule(settings.interval, block: self.notify)
        }
                
        /* Actions */
        
        @IBAction func actionDebugNotifyNow(_ sender: NSMenuItem) {
            notify()
        }
        
        @IBAction func actionAbout(_ sender: NSMenuItem) {
            NSApplication.shared().activate(ignoringOtherApps: true)
            aboutWindowController.showWindow(nil)
        }
        
        @IBAction func actionChangeInterval(_ sender: NSMenuItem) {
            changeInterval(sender.tag)
        }
        
        @IBAction func actionPause(_ sender: NSMenuItem) {
            settings.pauseInterval = sender.tag
            scheduler.pause(sender.tag)
        }
        
        @IBAction func actionResume(_ sender: NSMenuItem) {
            settings.pauseInterval = 0
            scheduler.resume()
        }
        
        @IBAction func actionChangeText(_ sender: NSMenuItem) {
            loadText(QuoteType(tag: sender.tag)!)  // TODO error handling
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
            
            if menuItem.action == #selector(self.actionChangeInterval) {
                menuItem.state = menuItem.tag == settings.interval ? 1 : 0
                
            } else if menuItem.action == #selector(self.actionChangeText) {
                menuItem.state = settings.quoteType.tag() == menuItem.tag ? 1 : 0
                
            } else if menuItem.action == #selector(self.actionChangeSound) {
                menuItem.state = settings.soundType.tag() == menuItem.tag ? 1 : 0
                
            } else if menuItem.action == #selector(self.actionChangeAutoLaunch) {
                menuItem.state = settings.autoLaunch ? 1 : 0
                
            } else if menuItem.action == #selector(self.actionPause) {
                menuItem.state = scheduler.paused && menuItem.tag == settings.pauseInterval ? 1 : 0
                
            } else if menuItem.action == #selector(self.actionResume) {
                return scheduler.paused
            }
            
            return true
        }
        
        
        /* Logic */
        
        func changeInterval(_ seconds: Int) {
            settings.interval = seconds
            scheduler.schedule(settings.interval, block: self.notify)
        }
        
        func toggleAutoLaunch() {
            settings.autoLaunch = !settings.autoLaunch
            SMLoginItemSetEnabled(Constants.launcherBundleIdentifier as CFString, settings.autoLaunch)
        }
        
        func loadText(_ type: QuoteType) {
            
            guard let loaded = QuoteCollection(type: type) else {
                // TODO
                return
            }
            
            settings.quoteType = type
            self.quotes = loaded
        }
        
        func loadSound(_ type: SoundType) {
            
            guard let loaded = Sound(type: type) else {
                // TODO
                return
            }
            
            settings.soundType = type
            self.sound = loaded
        }
        
        func notify() {
            notificationWindowController.showWindowWithText(nil, quote: quotes.next())
            self.sound?.play()
        }
    }
