//
//  NotificationWindowController.swift
//  Hint
//
//  Created by Christopher Smith on 1/7/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

import Cocoa

class NotificationWindowController: NSWindowController {
    
    let windowMarginY: CGFloat = 30.0
    let windowMarginX: CGFloat = 7.0
    let animationDuration: Double = 0.5
    let visibleDuration: Double = 8.0
    
    var animating = false
    
    func showWindowWithText(_ sender: Any?, quote: Quote) {
        
        // refuse to do anything if animating, or visible.
        if animating {
            return
        }
        
        animating = true
        
        // set contents of quote view.
        let viewController = self.contentViewController as! NotificationViewController
        viewController.setQuote(quote)

        prepare()
        animateIn()
    }
    
    func prepare() {
        
        // calculate window position, off right side of screen.
        let window = self.window!
        let screen = (NSScreen.screens()?.first)! as NSScreen
        let screenFrame = screen.frame
        let windowFrame = NSRect(
            x: screenFrame.width,
            y: screenFrame.height - window.frame.height - windowMarginY,
            width: window.frame.width,
            height: window.frame.height
        )
        
        // set window position and bring to front w/o focus.
        window.setFrame(windowFrame, display: true, animate: false)
        window.orderFrontRegardless()
        window.level = Int(CGWindowLevelForKey(CGWindowLevelKey.popUpMenuWindow))
        window.makeKey()
    }
    
    func animateIn() {
        
        let window = self.window!
        
        // animate window in from the right.
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = animationDuration
            
            let currentFrame = window.frame
            let nextFrame = NSRect(
                x: currentFrame.origin.x - currentFrame.width - windowMarginX,
                y: currentFrame.origin.y,
                width: currentFrame.width,
                height: currentFrame.height
            )
            window.animator().setFrame(nextFrame, display: true, animate: true)
            
        }, completionHandler: {() -> Void in
            
            // hold visible, then animate out.
            Timer.scheduledTimer(
                timeInterval: self.visibleDuration,
                target: self,
                selector: #selector(self.animateOut),
                userInfo: nil,
                repeats: false
            )
        })
    }
    
    func animateOut() {
        
        let window = self.window!
        let screen = (NSScreen.screens()?.first)! as NSScreen
        let screenFrame = screen.frame
        
        // animate window out, offscreen to the right
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = animationDuration
            
            let currentFrame = window.frame
            let nextFrame = NSRect(
                x: screenFrame.width + windowMarginX,
                y: currentFrame.origin.y,
                width: currentFrame.width,
                height: currentFrame.height
            )
            window.animator().setFrame(nextFrame, display: true, animate: true)

        }, completionHandler: {() -> Void in
            window.orderOut(nil)
            self.animating = false
        })
    }
}
