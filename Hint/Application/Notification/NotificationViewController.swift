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
    
    @IBOutlet var textView: NSTextView!
    @IBOutlet var textScrollView: NSScrollView!
    
    @IBOutlet var sourceView: NSTextView!
    @IBOutlet var sourceScrollView: NSScrollView!
    @IBOutlet var rightQuoteView: NSScrollView!
    @IBOutlet var leftQuoteView: NSScrollView!
    
    func setQuote(_ quote: Quote) {
        setQuoteText(quote.text)
        setQuoteSource(quote.source)
        positionQuote()
        positionRightQuote()
    }
    
    func setQuoteText(_ string: String) {
        
        let font = NSFont(name: "Georgia Italic", size: 15)!
        let attr = NSMutableAttributedString(string: string)
        let range = NSMakeRange(0, attr.length)
        let color = NSColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 20.0
        style.maximumLineHeight = 20.0
        
        attr.beginEditing()
        attr.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        attr.addAttribute(NSFontAttributeName, value: font, range: range)
        attr.addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
        attr.endEditing()
        
        textView.textStorage?.mutableString.setString("")
        textView.textStorage?.append(attr)
    }
    
    func setQuoteSource(_ string: String) {

        let font = NSFont(name: "Georgia Italic", size: 15)!
        let attr = NSMutableAttributedString(string: "—" + string)
        let range = NSMakeRange(0, attr.length)
        let color = NSColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0)
        let style = NSMutableParagraphStyle()
        style.alignment = .right
        
        attr.beginEditing()
        attr.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        attr.addAttribute(NSFontAttributeName, value: font, range: range)
        attr.addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
        attr.endEditing()
        
        self.sourceView.textStorage?.mutableString.setString("")
        self.sourceView.textStorage?.append(attr)
    }
    
    func positionRightQuote() {
        textView.layoutManager?.ensureLayout(for: textView.textContainer!)
        let layoutManager = textView.layoutManager!
        let lastUsedRect = layoutManager.lineFragmentUsedRect(
            forGlyphAt: layoutManager.numberOfGlyphs - 1,
            effectiveRange: nil
        )
        let point = NSPoint(
            x: lastUsedRect.width + 15,
            //y: 120 - lastUsedRect.origin.y-rightQuoteView.frame.height - 8
            y: textScrollView.frame.origin.y - 8
        )
        NSLog("tvFrameO: \(textScrollView.frame.origin), height: \(rightQuoteView.frame.height), quote point: \(point)")
        
        rightQuoteView.setFrameOrigin(point)
        
        let point2 = NSPoint(
            x: leftQuoteView.frame.origin.x,
            y: textScrollView.frame.origin.y + textScrollView.frame.height - 26
        )
        NSLog("\(leftQuoteView.frame.height)")
        leftQuoteView.setFrameOrigin(point2)
    }
    
    func positionQuote() {
        
        textView.layoutManager?.ensureLayout(for: textView.textContainer!)
        sourceView.layoutManager?.ensureLayout(for: sourceView.textContainer!)
        
        let textUsedRect = textView.layoutManager!.usedRect(for: textView.textContainer!)
        let sourceUsedRect = sourceView.layoutManager!.usedRect(for: sourceView.textContainer!)
        
        let textScrollViewSize = NSSize(
            width: textScrollView.frame.width,
            height: textUsedRect.height + 5
        )
        let textScrollVieWOrigin = NSPoint(
            x: textScrollView.frame.origin.x,
            y: (view.frame.height - textScrollViewSize.height + sourceScrollView.frame.height) / 2
        )

        textScrollView.setFrameSize(textScrollViewSize)
        textScrollView.setFrameOrigin(textScrollVieWOrigin)
        
        let sourceScrollViewSize = NSSize(
            width: sourceScrollView.frame.width,
            height: sourceUsedRect.height + 5
        )
        let sourceScrollViewOrigin = NSPoint(
            x: sourceScrollView.frame.origin.x,
            y: textScrollView.frame.origin.y - sourceScrollView.frame.height
        )
        sourceScrollView.setFrameSize(sourceScrollViewSize)
        sourceScrollView.setFrameOrigin(sourceScrollViewOrigin)
    }
}
