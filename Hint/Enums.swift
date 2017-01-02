//
//  Enums.swift
//  Hint
//
//  Created by Christopher Smith on 1/2/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

import Foundation


enum MessageType: String {
    
    case hints = "Hints"
    
    init(saved: String?) {
        switch saved {
        case nil: self = .hints
        default:
            if let new = MessageType.init(rawValue: saved!) {
                self = new
            } else {
                self = .hints
            }
        }
    }
    
    init?(tag: Int) {
        switch tag {
        case 0: self = .hints
        default: return nil
        }
    }
    
    func tag() -> Int {
        switch self {
        case .hints: return 0
        }
    }
}

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
