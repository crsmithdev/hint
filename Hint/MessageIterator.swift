//
//  TextSource.swift
//  Hint
//
//  Created by Christopher Smith on 12/29/16.
//  Copyright © 2016 Chris Smith. All rights reserved.
//

import Foundation
import Cocoa

enum MessageIteratorError: Error {
    case resourceNotFoundError
    case resourceEmptyError
}

class MessageIterator {

    static func fromFile(name: String) throws -> MessageIterator {
        
        let path = Bundle.main.path(forResource: name, ofType: "txt")
        
        if path == nil {
            throw MessageIteratorError.resourceNotFoundError
        }
        
        let contents = try String(contentsOfFile: path!)
        let trimmed = contents.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let lines = trimmed.components(separatedBy: "\n")
        
        DLog("loaded text from file: \(path), lines: \(lines)")
        
        let iter = MessageIterator(lines: lines)
        
        if iter == nil {
            throw MessageIteratorError.resourceEmptyError
        }
        
        return iter!
    }
    
    var cursor = 0
    var lines: [String] = []
    
    init?(lines: [String]) {
        
        if lines.count < 1 {
            return nil
        }
        
        self.lines = lines
        self.cursor = 0
    }
    
    func next() -> String {
        let text = lines[cursor]
        cursor = cursor < lines.count - 1 ? cursor + 1 : 0
        return text
    }
}
