//
//  NotificationViewController.swift
//  Hint
//
//  Created by Christopher Smith on 1/7/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

import Foundation
import Cocoa

class NotificationViewController: NSViewController {
    
    @IBOutlet var text: NSTextView!
    @IBOutlet var source: NSTextView!
    @IBOutlet var rightQuote: NSTextView!
    @IBOutlet var rightScrollView: NSScrollView!
    
    func setQuote(_ quote: Quote) {
        
        let attr = NSMutableAttributedString(string: quote.text)
        let range = NSMakeRange(0, attr.length)
        attr.beginEditing()
        attr.addAttribute(NSForegroundColorAttributeName, value: NSColor.white, range: range)
        attr.addAttribute(NSFontAttributeName, value: NSFont(name: "Georgia", size: 16)!, range: range)
        attr.endEditing()
        self.text.textStorage?.mutableString.setString("")
        self.text.textStorage?.append(attr)
        
        //let source = "-" + quote.source
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        let attr2 = NSMutableAttributedString(string: "-" + quote.source)
        let range2 = NSMakeRange(0, attr2.length)
        attr2.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range2)

        attr2.beginEditing()
        attr2.addAttribute(NSForegroundColorAttributeName, value: NSColor.white, range: range2)
        attr2.addAttribute(NSFontAttributeName, value: NSFont(name: "Georgia Italic", size: 16)!, range: range2)
        attr2.endEditing()
        
        self.source.textStorage?.mutableString.setString("")
        self.source.textStorage?.append(attr2)
        temp()
    }
    
    func temp() {
        let layoutManager = text.layoutManager
        let numberOfGlyphs = layoutManager?.numberOfGlyphs
        var numberOfLines = 0
        var index = 0
        var range2 = NSRange()
        var lastRect: NSRect = NSRect()
        
        while index < numberOfGlyphs! {
            var rect = layoutManager?.lineFragmentUsedRect(forGlyphAt: index, effectiveRange: &range2)
            index = NSMaxRange(range2)
            numberOfLines += 1
            NSLog("\(numberOfLines), \(rect)")
            lastRect = rect!
        }
        
        NSLog("last rect: \(lastRect.origin.y) \(lastRect.width)")
        let frame = rightQuote.frame
        let newRect = NSRect(x: lastRect.width, y: lastRect.origin.y, width: frame.width, height: frame.height)
        //rightQuote.setFrameOrigin(newRect.origin)
        //rightQuote.needsDisplay = true
        //rightQuote.needsLayout = true
        NSLog("frame: \(rightScrollView.frame)")
        let p = NSPoint(x: lastRect.width + 13, y: 120-lastRect.origin.y-rightScrollView.frame.height-5)
        rightScrollView.setFrameOrigin(p)
        //rightScrollView.setIsF .isFlipped = true
        NSLog("frame: \(rightScrollView.frame)")
        //NSLog("\(numberOfLines)")
    }
}
