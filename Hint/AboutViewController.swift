//
//  AboutDelegate.swift
//  Hint
//
//  Created by Christopher Smith on 12/31/16.
//  Copyright © 2016 Chris Smith. All rights reserved.
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
