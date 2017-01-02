//
//  Notifier.swift
//  Hint
//
//  Created by Christopher Smith on 12/29/16.
//  Copyright © 2016 Chris Smith. All rights reserved.
//

import Foundation
import Cocoa

class Notifier {
    
    static let shared = Notifier()
    
    func send(_ text: String, sound: NSSound?) {
        
        let notification = NSUserNotification()
        notification.title = "Hint"
        notification.informativeText = text
        
        NSUserNotificationCenter.default.removeAllDeliveredNotifications()
        NSUserNotificationCenter.default.deliver(notification)
        
        sound?.play()
        
        if sound != nil {
            DLog("\(sound!.volume)")
        }
        
        DLog("sent notification, message: '\(text)', sound: \(sound?.name)")
    }
}
