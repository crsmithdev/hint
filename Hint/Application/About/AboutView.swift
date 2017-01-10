//
//  AboutController.swift
//  Hint
//
//  Created by Christopher Smith on 1/7/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

import Cocoa

class AboutView: NSView {
    
    @IBOutlet var sourceButton: NSButton!
    
    @IBAction func actionClickLink(_ sender: NSButton) {
        NSWorkspace.shared().open(Constants.sourceURL)
    }
}
