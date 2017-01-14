//
//  OverlayView.swift
//  Hint
//
//  Created by Christopher Smith on 1/14/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

import Cocoa


class OverlayView: NSView {
    
    override func mouseDown(with event: NSEvent) {
        (window?.windowController as? NotificationWindowController)?.dismiss()
    }
}
