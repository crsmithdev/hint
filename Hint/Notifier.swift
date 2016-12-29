//
//  Notifier.swift
//  Hint
//
//  Created by Christopher Smith on 12/29/16.
//  Copyright © 2016 Chris Smith. All rights reserved.
//

import Foundation

class Notifier {
    
    static let shared = Notifier()
    
    func notify(text: String) -> Void {
        
        let notification = NSUserNotification()
        notification.title = "Hint"
        notification.informativeText = text
        
        NSUserNotificationCenter.default.removeAllDeliveredNotifications()
        NSUserNotificationCenter.default.deliver(notification)
    }
}
