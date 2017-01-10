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
    @IBOutlet var versionField: NSTextField!
    
    @IBAction func actionClickLink(_ sender: NSButton) {
        NSWorkspace.shared().open(Constants.sourceURL)
    }
    
    override func viewWillDraw() {
        super.viewWillDraw()
        versionField.stringValue = getVersionString()
    }
    
    func getVersionString() -> String {
        let dict = Bundle.main.infoDictionary!
        let version = dict["CFBundleShortVersionString"] as! String
        return "Version \(version)"
    }
}
