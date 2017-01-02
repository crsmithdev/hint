//
//  Configuration.swift
//  Hint
//
//  Created by Christopher Smith on 12/31/16.
//  Copyright © 2016 Chris Smith. All rights reserved.
//

import Foundation

class Constants {
    
    static let sourceURL = URL(string: "https://github.com/crsmithdev/hint")!
    
    static let notificationIntervalKey = "NotificationInterval"
    static let defaultNotificationInterval = 300
    
    static let notificationTextKey = "NotificationText"
    static let defaultNotificationText = "Hints"
    
    static let notificationSoundKey = "NotificationSound"
    static let defaultNotificationSound = ""
    
    static let autoLaunchKey = "AutoLaunch"
    static let defaultAutoLaunch = false
}
