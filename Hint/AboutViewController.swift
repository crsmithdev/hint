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
    
    override func viewDidLoad() {
        sourceButton.attributedTitle = linkFromString(sourceButton.title, url: Constants.sourceURL)
    }
    
    @IBAction func actionLinkClick(_ sender: NSButton) {
        NSWorkspace.shared().open(Constants.sourceURL)
    }
}

class LinkButton: NSButton {
    
    override func resetCursorRects() {
        addCursorRect(bounds, cursor: NSCursor.pointingHand())
    }
}
