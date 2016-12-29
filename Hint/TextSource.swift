//
//  TextSource.swift
//  Hint
//
//  Created by Christopher Smith on 12/29/16.
//  Copyright © 2016 Chris Smith. All rights reserved.
//

import Foundation

class TextSource {
    
    static func fromFile(path: String) throws -> TextSource {
        
        let contents = try String(contentsOfFile: path)
        let trimmed = contents.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let lines = trimmed.components(separatedBy: "\n")
        
        DLog("loaded text from file: \(path), lines: \(lines)")
        
        return TextSource(lines: lines)
    }
    
    var cursor = 0
    var lines: [String] = []
    
    init(lines: [String]) {
        
        self.lines = lines
        self.cursor = 0
    }
    
    func next() -> String {
        // TODO 0-length
        
        let text = lines[cursor]
        cursor = cursor < lines.count - 1 ? cursor + 1 : 0
        return text
    }
}
