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
        
        if type != .silent {
            let path = Bundle.main.path(forResource: type.rawValue, ofType: "wav")
            
            if path == nil {
                return nil
            }
            
            let sound = NSSound(contentsOfFile: path!, byReference: false)
            
            if sound == nil {
                return nil
            }
            
            self.sound = sound!
        }
    }
    
    func play() {
        if type != .silent {
            self.sound?.play()
        }
    }
}
