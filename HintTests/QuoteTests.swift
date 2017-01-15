//
//  QuoteTests.swift
//  Hint
//
//  Created by Christopher Smith on 1/15/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

import XCTest
@testable import Hint

class QuoteTypeTests: XCTestCase {
    
    func testSaved() {
        XCTAssertEqual(QuoteType(saved: QuoteType.hints.rawValue), QuoteType.hints)
        XCTAssertEqual(QuoteType(saved: nil), QuoteType.hints)
        XCTAssertEqual(QuoteType(saved: "error"), QuoteType.hints)
    }
    
    func testTag() {
        XCTAssertEqual(QuoteType(tag: QuoteType.hints.tag()), QuoteType.hints)
        XCTAssertEqual(SoundType(tag: -1), nil)
    }
}

class QuoteCollectionTests: XCTestCase {
    
    func testInitQuoteType() {
        let quotes = QuoteCollection(type: QuoteType.hints)
        XCTAssertNotNil(quotes)
        XCTAssert(quotes!.count > 0)
    }
    
    func testInitEmpty() {
        let quotes = QuoteCollection(contents: "")
        XCTAssertNil(quotes)
    }
    
    func testInitMalformed() {
        let contents = "quote|source\nquote"
        let quotes = QuoteCollection(contents: contents)
        XCTAssertNotNil(quotes)
        XCTAssertEqual(quotes!.count, 1)
    }
    
    func testNext() {
        let contents = "quote1|source1\nquote2|source2"
        let quotes = QuoteCollection(contents: contents)!
        XCTAssertEqual(quotes.next(), Quote(text: "quote1", source: "source1"))
        XCTAssertEqual(quotes.next(), Quote(text: "quote2", source: "source2"))
        XCTAssertEqual(quotes.next(), Quote(text: "quote1", source: "source1"))
 }
}
