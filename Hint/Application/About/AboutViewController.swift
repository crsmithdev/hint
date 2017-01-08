//
//  AboutController.swift
//  Hint
//
//  Created by Christopher Smith on 1/7/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

import Cocoa

class AboutViewController: NSViewController {
    
    @IBOutlet var sourceButton: NSButton!
    
    @IBAction func actionLinkClick(_ sender: NSButton) {
        NSWorkspace.shared().open(Constants.sourceURL)
    }
}

class LinkButton: NSButton {
    
    override func viewWillDraw() {
        super.viewWillDraw()
        self.attributedTitle = linkFromString(self.title, url: Constants.sourceURL)
    }
        
    override func resetCursorRects() {
        addCursorRect(bounds, cursor: NSCursor.pointingHand())
    }
    
    func linkFromString(_ string: String, url: URL) -> NSAttributedString {
        
        let attr = NSMutableAttributedString(string: string)
        let range = NSMakeRange(0, attr.length)
        
        attr.beginEditing()
        attr.addAttribute(NSLinkAttributeName, value: url.absoluteString, range: range)
        attr.addAttribute(NSForegroundColorAttributeName, value: NSColor.blue, range: range)
        attr.addAttribute(NSUnderlineStyleAttributeName, value: 1, range: range)
        attr.addAttribute(NSFontAttributeName, value: NSFont(name: "Helvetica Neue", size: 13)!, range: range)
        attr.endEditing()
        
        return attr
    }
}
