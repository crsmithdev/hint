//
//  LinkButton.swift
//  Hint
//
//  Created by Christopher Smith on 1/8/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

import Cocoa

class LinkButton: NSButton {
    
    override func viewWillDraw() {
        super.viewWillDraw()
        self.attributedTitle = getAttributedTitle(self.title)
    }
    
    override func resetCursorRects() {
        addCursorRect(bounds, cursor: NSCursor.pointingHand())
    }
    
    func getAttributedTitle(_ string: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [
            NSForegroundColorAttributeName: NSColor.blue,
            NSUnderlineStyleAttributeName: 1,
            NSFontAttributeName: NSFont(name: "Helvetica Neue", size: 13)!
        ])
    }
}
