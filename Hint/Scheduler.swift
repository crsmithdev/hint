//
//  Scheduler.swift
//  Hint
//
//  Created by Christopher Smith on 1/1/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

import Foundation

typealias ScheduledFunc = () -> (Void)

class Scheduler: NSObject {
    
    var scheduledFunc: ScheduledFunc?
    var timer: Timer?
    var pauseTimer: Timer?
    private(set) var paused: Bool = false
    private(set) var interval: Int?
    
    func schedule(_ seconds: Int, block: @escaping ScheduledFunc) {
        
        scheduledFunc = block
        interval = seconds
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: TimeInterval(seconds),
            target: self,
            selector: #selector(self.tick),
            userInfo: nil,
            repeats: true
        )
        
        DLog("scheduled for \(seconds)s")
    }

    func pause(_ seconds: Int? = nil) {
        
        paused = true
        
        if seconds == nil {
            DLog("paused until resumed")
            return
        }
        
        pauseTimer?.invalidate()
        pauseTimer = Timer.scheduledTimer(
            timeInterval: TimeInterval(seconds!),
            target: self,
            selector: #selector(self.resume),
            userInfo: nil,
            repeats: false
        )
        
        DLog("paused for \(seconds!)s")
    }
    
    func resume() {
        paused = false
        DLog("resumed")
    }
    
    func tick() {
        
        if paused {
            return
        }
        
        if scheduledFunc != nil {
            scheduledFunc!()
        }
    }
}
