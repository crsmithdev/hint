//
//  LinkButton.swift
//  Hint
//
//  Created by Christopher Smith on 1/8/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

import Foundation
import Cocoa

class LinkButton: NSButton {
    
    override func viewWillDraw() {
        super.viewWillDraw()
        self.attributedTitle = buildAttributedTitle(self.title)
    }
    
    override func resetCursorRects() {
        addCursorRect(bounds, cursor: NSCursor.pointingHand())
    }
    
    func buildAttributedTitle(_ string: String) -> NSAttributedString {
        
        let attr = NSMutableAttributedString(string: string)
        let range = NSMakeRange(0, attr.length)
        
        attr.beginEditing()
        attr.addAttribute(NSForegroundColorAttributeName, value: NSColor.blue, range: range)
        attr.addAttribute(NSUnderlineStyleAttributeName, value: 1, range: range)
        attr.addAttribute(NSFontAttributeName, value: NSFont(name: "Helvetica Neue", size: 13)!, range: range)
        attr.endEditing()
        
        return attr
    }
}
