//
//  Settings.swift
//  Hint
//
//  Created by Christopher Smith on 1/8/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

import Foundation

class Settings {
    
    private struct Keys {
        static let intervalKey = "NotificationInterval"
        static let quoteTypeKey = "QuoteType"
        static let soundTypeKey = "SoundType"
        static let autoLaunchKey = "AutoLaunch"
        static let shuffleKey = "Shuffle"
    }
    
    private struct Defaults {
        static let interval = 300
    }

    private let defaults: UserDefaults
    
    var interval: Int {
        get { return defaults.integer(forKey: Keys.intervalKey) }
        set (value) { defaults.set(value, forKey: Keys.intervalKey) }
    }
    
    var soundType: SoundType {
        get { return SoundType(saved: defaults.string(forKey: Keys.soundTypeKey)) }
        set (value) { defaults.set(value.rawValue, forKey: Keys.soundTypeKey) }
    }
    
    var quoteType: QuoteType {
        get { return QuoteType(saved: defaults.string(forKey: Keys.quoteTypeKey)) }
        set (value) { defaults.set(value.rawValue, forKey: Keys.quoteTypeKey) }
    }
    
    var autoLaunch: Bool {
        get { return defaults.bool(forKey: Keys.autoLaunchKey) }
        set (value) { defaults.set(value, forKey: Keys.autoLaunchKey) }
    }
    
    var shuffle: Bool {
        get { return defaults.bool(forKey: Keys.shuffleKey) }
        set (value) { defaults.set(value, forKey: Keys.shuffleKey) }
    }
    
    var pauseInterval: Int = 0
    
    init(_ defaults: UserDefaults) {
        
        self.defaults = defaults
        
        if self.interval == 0 {
            self.interval = Defaults.interval
        }
    }
}
