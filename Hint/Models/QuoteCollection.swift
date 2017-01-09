//
//  QuoteCollection.swift
//  Hint
//
//  Created by Christopher Smith on 1/8/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

import Foundation

enum QuoteType: String {
    
    case hints = "Hints"
    
    init(saved: String?) {
        switch saved {
        case nil: self = .hints
        default:
            if let new = QuoteType.init(rawValue: saved!) {
                self = new
            } else {
                self = .hints
            }
        }
    }
    
    init?(tag: Int) {
        switch tag {
        case 0: self = .hints
        default: return nil
        }
    }
    
    func tag() -> Int {
        switch self {
        case .hints: return 0
        }
    }
}

class QuoteCollection {
    
    init?(type: QuoteType) {
        
        guard let path = Bundle.main.path(forResource: type.rawValue, ofType: "txt") else {
            NSLog("could not load quote resource, type: \(type)")
            return nil
        }
        
        guard let contents = try? String(contentsOfFile: path) else {
            NSLog("could not load contents of quote resource, type: \(type), path: \(path)")
            return nil
        }
        
        let trimmed = contents.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let lines = trimmed.components(separatedBy: "\n")
        //var quotes: [Quote] = []
        
        for line in lines {
            let components = line.components(separatedBy: "|")
            if components.count >= 2 {
                quotes.append(Quote(text: components[0], source: components[1]))
            }
        }

        
            
        DLog("loaded quotes from file: \(path), lines: \(lines)")
    }
    
    var cursor = 0
    //var lines: [String] = []
    var quotes: [Quote] = []
    
    /*
    init?(lines: [String]) {
        
        if lines.count < 1 {
            return nil
        }
        
        self.lines = lines
        self.cursor = 0
    }
    */
    
    func next() -> Quote {
        let quote = quotes[cursor]
        //let text = lines[cursor]
        cursor = cursor < quotes.count - 1 ? cursor + 1 : 0
        return quote
    }
}
