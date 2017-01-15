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
                NSLog("failed loading quotes from saved value: \(saved), defaulting to: \(self)")
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
    
    private static let separator = "|"
    
    convenience init?(type: QuoteType) {
        
        // load csv from resource file.
        guard let path = Bundle.main.path(forResource: type.rawValue, ofType: "csv"),
            let contents = try? String(contentsOfFile: path) else {
                NSLog("failed loading quotes, type: \(type)")
                return nil
        }
        
        self.init(contents: contents)
    }
    
    init?(contents: String) {
    
        // trim whitespace and split.
        let trimmed = contents.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let lines = trimmed.components(separatedBy: "\n")
        var quotes: [Quote] = []
        
        // split by separator, include only quotes with >= 2 values
        for line in lines {
            let components = line.components(separatedBy: QuoteCollection.separator)
            if components.count < 2 {
                NSLog("loaded malformed quote: \(line), skipping")
            } else {
                quotes.append(Quote(text: components[0], source: components[1]))
            }
        }
        
        // fail if 0 quotes, impossible to iterate over empty collection.
        if quotes.count == 0 {
            NSLog("loaded quotes with no valid lines, contents: \(contents)")
            return nil
        }
        
        self.originalOrder = quotes
        self.readOrder = quotes

        DLog("loaded quotes, count: \(quotes.count)")
    }
    
    let originalOrder: [Quote]
    var cursor = 0
    var readOrder: [Quote]
    var count: Int {
        get { return originalOrder.count }
    }
    
    func next() -> Quote {
        let quote = readOrder[cursor]
        cursor = cursor < readOrder.count - 1 ? cursor + 1 : 0
        return quote
    }
    
    func shuffle() {
        readOrder = originalOrder.shuffled()
        DLog("shuffled quotes")
    }
    
    func unShuffle() {
        
        let next = readOrder[cursor]
        NSLog("next: \(next.text)")
        for i in 0..<originalOrder.count {
            if originalOrder[i] == next {
                cursor = i
            }
        }
        
        readOrder = originalOrder
        DLog("unShuffled quotes, cursor: \(cursor)")
    }
}

extension Array {
    
    func shuffled() -> [Array.Element] {
        
        var shuffled = self
        for i in 0 ..< (count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            if i != j {
                swap(&shuffled[i], &shuffled[j])
            }
        }
        
        return shuffled
    }
}
