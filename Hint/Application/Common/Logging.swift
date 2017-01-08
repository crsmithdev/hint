//
//  Logging.swift
//  Hint
//
//  Created by Christopher Smith on 12/29/16.
//  Copyright © 2016 Chris Smith. All rights reserved.
//

import Foundation

func DLog(_ message: String, _ function: String = #function) {
    #if DEBUG
        NSLog("\(function): \(message)")
    #endif
}
