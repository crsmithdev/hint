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
    case debug = "Debug"
    
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
        case 99: self = .debug
        default: return nil
        }
    }
    
    func tag() -> Int {
        switch self {
        case .hints: return 0
        case .debug: return 99
        }
    }
}

class QuoteCollection {
    
    private static let separator = "|"
    
    init?(type: QuoteType) {
        
        // load csv from resource file.
        guard let path = Bundle.main.path(forResource: type.rawValue, ofType: "csv"),
            let contents = try? String(contentsOfFile: path) else {
                NSLog("failed loading quotes, type: \(type)")
                return nil
        }
        
        // trim whitespace and split.
        let trimmed = contents.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let lines = trimmed.components(separatedBy: "\n")
        var index = 0
        
        // split by separator, include only quotes with >= 2 values
        for line in lines {
            let components = line.components(separatedBy: QuoteCollection.separator)
            if components.count >= 2 {
                quotes.append(Quote(id: index, text: components[0], source: components[1]))
                index += 1
            } else {
                NSLog("loaded malformed quote: \(line), skipping")
            }
        }
        
        // fail if 0 quotes, impossible to iterate over empty collection.
        if quotes.count == 0 {
            NSLog("loaded quotes with no valid lines, type: \(type), contents: \(contents)")
            return nil
        }

        DLog("loaded quotes, type: \(type), path: \(path), count: \(quotes.count)")
    }
    
    var cursor = 0
    var currentId = 0
    var quotes: [Quote] = []
    
    func next() -> Quote {
        let quote = quotes[cursor]
        cursor = cursor < quotes.count - 1 ? cursor + 1 : 0
        currentId = quotes[cursor].id
        return quote
    }
    
    func shuffle() {
        quotes.shuffle()
        DLog("shuffled quotes, order: \(quotes.map { return $0.id }), cursor: \(cursor), currentId: \(currentId)")
    }
    
    func unShuffle() {
        quotes.sort { return $0.id < $1.id }
        cursor = currentId
        DLog("unShuffled quotes, order: \(quotes.map { return $0.id }), cursor: \(cursor), currentId: \(currentId)")
    }
}

extension Array {
    mutating func shuffle() {
        for i in 0 ..< (count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            if i != j {
                swap(&self[i], &self[j])
            }
        }
    }
}
