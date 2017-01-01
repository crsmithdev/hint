//
//  Logging.swift
//  Hint
//
//  Created by Christopher Smith on 12/29/16.
//  Copyright © 2016 Chris Smith. All rights reserved.
//

import Foundation
import Cocoa

func DLog(_ message: String, _ function: String = #function) {
    #if DEBUG
        NSLog("\(function): \(message)")
    #endif
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
