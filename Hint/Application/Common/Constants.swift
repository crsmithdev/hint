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
    static let launcherBundleIdentifier = "com.crsmithdev.HintLauncher"
    
    static let intervalKey = "NotificationInterval"
    static let intervalDefault = 300
    static let intervalRapid = 20

    static let quoteTypeKey = "QuoteType"
    static let soundTypeKey = "SoundType"
    static let autoLaunchKey = "AutoLaunch"
}
