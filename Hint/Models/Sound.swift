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

extension NSSound {
    
    convenience init?(soundType: SoundType) {
        
        if soundType == .silent {
            return nil
        }
        
        guard let file = Bundle.main.path(forResource: soundType.rawValue, ofType: "wav") else {
            return nil
        }
        
        self.init(contentsOfFile: file, byReference: false)
    }
}
