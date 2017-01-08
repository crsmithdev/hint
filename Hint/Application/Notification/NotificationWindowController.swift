//
//  NotificationWindowController.swift
//  Hint
//
//  Created by Christopher Smith on 1/7/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

import Cocoa
import Foundation

class NotificationWindowController: NSWindowController {
    
    func showWindowWithText(_ sender: Any?, text: String) {
        let viewController = self.contentViewController as! NotificationViewController
        viewController.setText(text: text)
        notify2()
    }
    
    func notify2() {
        
        let window = self.window!
        let screen = (NSScreen.screens()?.first)! as NSScreen
        let screenRect = screen.visibleFrame
        
        func prepare() {
            let origin = CGPoint(
                x: screenRect.width + 10,
                y: screenRect.height - window.frame.height - 10)
            let rect = NSRect(origin: origin, size: window.frame.size)
            window.setFrame(rect, display: true, animate: false)
            window.orderFrontRegardless()
            window.level = Int(CGWindowLevelForKey(CGWindowLevelKey.popUpMenuWindow))
            window.makeKey()
        }
        
        prepare()
        animateIn()
    }
    
    func animateIn() {
        let window = self.window!
        
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.5
            let currentFrame = window.frame
            let currentOrigin = currentFrame.origin
            let newOrigin = CGPoint(x: currentOrigin.x - currentFrame.width - 25, y: currentOrigin.y)
            let newFrame = NSRect(origin: newOrigin, size: currentFrame.size)
            window.animator().setFrame(newFrame, display: true, animate: true)
        }, completionHandler: {() -> Void in
            Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.animateOut), userInfo: nil, repeats: false)
            
            
        })
    }
    
    func animateOut() {
        let window = self.window!
        let screen = (NSScreen.screens()?.first)! as NSScreen
        let screenRect = screen.visibleFrame
        
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.5
            let currentFrame = window.frame
            let currentOrigin = currentFrame.origin
            let newOrigin = CGPoint(x: screenRect.width + 10, y: currentOrigin.y)
            let newFrame = NSRect(origin: newOrigin, size: currentFrame.size)
            window.animator().setFrame(newFrame, display: true, animate: true)
            //window.animator().frame = newFrame
        }, completionHandler: {() -> Void in
            window.orderOut(nil)
            NSLog("done")
        })
        
    }
}
