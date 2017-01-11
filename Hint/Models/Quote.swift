//
//  Quote.swift
//  Hint
//
//  Created by Christopher Smith on 1/8/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

class Quote {
    let text: String
    let source: String
    let id: Int
    
    init(id: Int, text: String, source: String) {
        self.id = id
        self.text = text
        self.source = source
    }
}
