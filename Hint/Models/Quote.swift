//
//  Quote.swift
//  Hint
//
//  Created by Christopher Smith on 1/8/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

class Quote: Equatable {
    
    public static func ==(lhs: Quote, rhs: Quote) -> Bool {
        return lhs.text == rhs.text && lhs.source == rhs.source
    }
    
    let text: String
    let source: String
    
    init(text: String, source: String) {
        self.text = text
        self.source = source
    }
}
