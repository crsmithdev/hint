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
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 20.0
        style.maximumLineHeight = 20.0
        
        attr.beginEditing()
        attr.addAttribute(NSForegroundColorAttributeName, value: NSColor.white, range: range)
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
        let style = NSMutableParagraphStyle()
        style.alignment = .right
        
        attr.beginEditing()
        attr.addAttribute(NSForegroundColorAttributeName, value: NSColor.white, range: range)
        attr.addAttribute(NSFontAttributeName, value: font, range: range)
        attr.addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
        attr.endEditing()
        
        self.sourceView.textStorage?.mutableString.setString("")
        self.sourceView.textStorage?.append(attr)
    }
    
    func positionRightQuote() {
        
        let layoutManager = textView.layoutManager!
        let lastUsedRect = layoutManager.lineFragmentUsedRect(
            forGlyphAt: layoutManager.numberOfGlyphs - 1,
            effectiveRange: nil
        )
        let point = NSPoint(
            x: lastUsedRect.width + 13,
            y: 120 - lastUsedRect.origin.y-rightQuoteView.frame.height - 8
        )
        
        rightQuoteView.setFrameOrigin(point)
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
        //let textHeight = textRect.height
        //let sourceHeight = sourceRect.height
        //let totalHeight = textHeight + sourceHeight
        //let viewHeight = view.frame.height
        //let margin = (viewHeight - totalHeight) / 2
        //textScrollView.setFrameOrigin(textRect.origin)
        //textScrollView.setFrameSize(textRect.size)

        textScrollView.setFrameSize(textScrollViewSize)
        textScrollView.setFrameOrigin(textScrollVieWOrigin)
        //textScrollView.setFrameOrigin(textOrigin)
        /*
        let origin = NSPoint(
            x: sourceScrollView.frame.origin.x,
            y: viewHeight - textHeight - sourceHeight - 20
        )
        */
        //sourceScrollView.setFrameOrigin(origin)
        //NSLog("margin: \(margin)")
        //NSLog("textScrollView.origin: \(textOrigin)")
        
        //NSLog("text height: \(textHeight), sourceHeight: \(sourceHeight), total: \(totalHeight), view: \(viewHeight)")
        //NSLog("\(origin)")
        
        /*
        let y = lastRect.origin.y + lastRect.height
        let y2 = layoutManager?.usedRect(for: textView.textContainer!)
        let totalHeight = view.frame.height
        NSLog("frame: \(rightQuoteView.frame), \(y), \(y2), \(totalHeight)")
        
        let layoutManager2 = sourceView.layoutManager!
        let textContainer2 = sourceView.textContainer!
        let y3 = layoutManager2.usedRect(for: textContainer2)
        NSLog("frame2: \(y3)")
        return p
        */
    }
}
