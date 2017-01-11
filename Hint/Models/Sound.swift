//
//  Sound.swift
//  Hint
//
//  Created by Christopher Smith on 1/8/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

import Foundation
import Cocoa

enum SoundType: String {
    
    case silent = ""
    case singingBowlLow = "SingingBowlLow"
    case singingBowlHigh = "SingingBowlHigh"
    
    init(saved: String?) {
        switch saved {
        case nil: self = .silent
        default:
            if let new = SoundType.init(rawValue: saved!) {
                self = new
            } else {
                self = .silent
                NSLog("failed loading sound from saved value: \(saved), defaulting to \(self)")
            }
        }
    }
    
    init?(tag: Int) {
        switch tag {
        case 0: self = .silent
        case 1: self = .singingBowlHigh
        case 2: self = .singingBowlLow
        default: return nil
        }
    }
    
    func tag() -> Int {
        switch self {
        case .silent: return 0
        case .singingBowlHigh: return 1
        case .singingBowlLow: return 2
        }
    }
}

class Sound {
    
    let type: SoundType
    private var sound: NSSound?
    
    init?(type: SoundType) {
        
        self.type = type
        
        if self.type == .silent {
            self.sound = nil
            return
        }
        
        guard let path = Bundle.main.path(forResource: self.type.rawValue, ofType: "wav"),
            let sound = NSSound(contentsOfFile: path, byReference: false) else {
                NSLog("failed loading sound, type: \(type)")
                return nil
        }
        
        self.sound = sound
        
        DLog("loaded sound, type: \(type), path: \(path), sound: \(sound)")
    }
    
    func play() {
        if type != .silent {
            self.sound?.play()
        }
    }
}
