//
//  NotificationViewController.swift
//  Hint
//
//  Created by Christopher Smith on 1/7/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

import Foundation
import Cocoa

class NotificationViewController: NSViewController {
    
    @IBOutlet var text: NSTextView!
    
    func setText(text: String) {
        
        let attr = NSMutableAttributedString(string: text)
        let range = NSMakeRange(0, attr.length)
        
        attr.beginEditing()
        attr.addAttribute(NSForegroundColorAttributeName, value: NSColor.white, range: range)
        //attr.addAttribute(NSFontAttributeName, value: NSFont(name: "Helvetica Neue", size: 13)!, range: range)
        attr.endEditing()
        
        //return attr
        NSLog("\(self.text)")
        self.text.textStorage?.mutableString.setString("")
        self.text.textStorage?.append(attr)
    }
}
