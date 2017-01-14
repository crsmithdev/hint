//
//  NotificationViewController.swift
//  Hint
//
//  Created by Christopher Smith on 1/7/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

import Cocoa


class NotificationViewController: NSViewController {
    
    @IBOutlet var textView: NSTextView!
    @IBOutlet var textScrollView: NSScrollView!
    
    @IBOutlet var sourceView: NSTextView!
    @IBOutlet var sourceScrollView: NSScrollView!
    
    @IBOutlet var rightQuoteScrollView: NSScrollView!
    @IBOutlet var leftQuoteScrollView: NSScrollView!
    
    let quoteTextFont = NSFont(name: "Georgia", size: 14)!
    let quoteTextColor = NSColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
    let quoteTextLineHeight: CGFloat = 19
    let quoteTextHeightPadding: CGFloat = 7
    
    let quoteSourceFont = NSFont(name: "Georgia Italic", size: 14)!
    let quoteSourceColor = NSColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0)
    let quoteSourceHeightPadding: CGFloat = 5
    
    let rightQuotationMarkXOffset: CGFloat = -8
    let rightQuotationMarkYOffset: CGFloat = -6
    let leftQuotationMarkXOffset: CGFloat = 0
    let leftQuotationMarkYOffset: CGFloat = -25
    
    func setQuote(_ quote: Quote) {
        
        setQuoteText(quote.text)
        setQuoteSource(quote.source)
        positionQuote()
        positionQuotationMarks()
    }
    
    func setQuoteText(_ string: String) {
        
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = quoteTextLineHeight
        style.maximumLineHeight = quoteTextLineHeight

        let attr = NSAttributedString(string: string, attributes: [
            NSForegroundColorAttributeName: quoteTextColor,
            NSFontAttributeName: quoteTextFont,
            NSParagraphStyleAttributeName: style,
            NSKernAttributeName: 0.05
        ])
        
        textView.textStorage?.mutableString.setString("")
        textView.textStorage?.append(attr)
    }
    
    func setQuoteSource(_ string: String) {

        let style = NSMutableParagraphStyle()
        style.alignment = .right
        
        let attr = NSAttributedString(string: "— " + string, attributes: [
            NSForegroundColorAttributeName: quoteSourceColor,
            NSFontAttributeName: quoteSourceFont,
            NSParagraphStyleAttributeName: style
        ])
        
        self.sourceView.textStorage?.mutableString.setString("")
        self.sourceView.textStorage?.append(attr)
    }
    
    func positionQuote() {
        
        let textLayoutManager = textView.layoutManager!
        let sourceLayoutManager = sourceView.layoutManager!
        
        // force layout.
        textLayoutManager.ensureLayout(for: textView.textContainer!)
        sourceLayoutManager.ensureLayout(for: sourceView.textContainer!)
        
        // get used rect for both parts.
        let textUsedRect = textLayoutManager.usedRect(for: textView.textContainer!)
        let sourceUsedRect = sourceLayoutManager.usedRect(for: sourceView.textContainer!)
        
        // find width of the longest line of quote text.
        var i = 0
        var width = 0
        while i < textLayoutManager.numberOfGlyphs {
            var range = NSRange()
            let rect = textLayoutManager.lineFragmentUsedRect(forGlyphAt: i, effectiveRange: &range)
            width = max(width, Int(rect.width))
            i = NSMaxRange(range)
        }
 
        // size and position quote text to center vertically, factoring in source.
        let textSize = NSSize(
            width: textScrollView.frame.width,
            height: textUsedRect.height + quoteTextHeightPadding
        )
        let textOrigin = NSPoint(
            x: (view.frame.width - CGFloat(width)) / 2,
            y: (view.frame.height - textSize.height + sourceScrollView.frame.height) / 2
        )
        
        textScrollView.setFrameSize(textSize)
        textScrollView.setFrameOrigin(textOrigin)
        
        // size and position quote source below text.
        let sourceSize = NSSize(
            width: sourceScrollView.frame.width,
            height: sourceUsedRect.height + quoteSourceHeightPadding
        )
        let sourceOrigin = NSPoint(
            x: sourceScrollView.frame.origin.x,
            y: textScrollView.frame.origin.y - sourceScrollView.frame.height
        )
        
        sourceScrollView.setFrameSize(sourceSize)
        sourceScrollView.setFrameOrigin(sourceOrigin)
    }
    
    func positionQuotationMarks() {

        textView.layoutManager?.ensureLayout(for: textView.textContainer!)

        // get the used rect for the last displayed line of quote text.
        let layoutManager = textView.layoutManager!
        let lastUsedRect = layoutManager.lineFragmentUsedRect(
            forGlyphAt: layoutManager.numberOfGlyphs - 1,
            effectiveRange: nil
        )
        
        // position left quotation mark against vertically-centered quote text.
        let leftOrigin = NSPoint(
            x: textScrollView.frame.origin.x - leftQuoteScrollView.frame.width + leftQuotationMarkXOffset,
            y: textScrollView.frame.origin.y + textScrollView.frame.height + leftQuotationMarkYOffset
        )
        leftQuoteScrollView.setFrameOrigin(leftOrigin)
    
        // position right quotation mark at end of last displayed character.
        let rightOrigin = NSPoint(
            x: textScrollView.frame.origin.x + lastUsedRect.width + rightQuotationMarkXOffset,
            y: textScrollView.frame.origin.y + rightQuotationMarkYOffset
        )
        rightQuoteScrollView.setFrameOrigin(rightOrigin)
    }
}
