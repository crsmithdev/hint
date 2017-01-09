//
//  Settings.swift
//  Hint
//
//  Created by Christopher Smith on 1/8/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

import Foundation

class Settings {
    
    private let defaults: UserDefaults
    
    var interval: Int {
        get { return defaults.integer(forKey: Constants.intervalKey) }
        set (value) { defaults.set(value, forKey: Constants.intervalKey) }
    }
    
    var soundType: SoundType {
        get { return SoundType(saved: defaults.string(forKey: Constants.soundTypeKey)) }
        set (value) { defaults.set(value.rawValue, forKey: Constants.soundTypeKey) }
    }
    
    var messageType: QuoteType {
        get { return QuoteType(saved: defaults.string(forKey: Constants.quoteTypeKey)) }
        set (value) { defaults.set(value.rawValue, forKey: Constants.quoteTypeKey) }
    }
    
    var autoLaunch: Bool {
        get { return defaults.bool(forKey: Constants.autoLaunchKey) }
        set (value) { defaults.set(value, forKey: Constants.autoLaunchKey) }
    }
    
    var pauseInterval: Int = 0
    
    init(_ defaults: UserDefaults) {
        
        self.defaults = defaults
        
        if self.interval == 0 {
            self.interval = Constants.intervalDefault
        }
    }
}
