//
//  SoundTests.swift
//  Hint
//
//  Created by Christopher Smith on 1/14/17.
//  Copyright © 2017 Chris Smith. All rights reserved.
//

import XCTest
@testable import Hint

class SoundTypeTests: XCTestCase {
    
    func testSaved() {
        XCTAssertEqual(SoundType(saved: SoundType.singingBowlLow.rawValue), SoundType.singingBowlLow)
        XCTAssertEqual(SoundType(saved: nil), SoundType.silent)
        XCTAssertEqual(SoundType(saved: "error"), SoundType.silent)
    }
    
    func testTag() {
        XCTAssertEqual(SoundType(tag: SoundType.silent.tag()), SoundType.silent)
        XCTAssertEqual(SoundType(tag: SoundType.singingBowlLow.tag()), SoundType.singingBowlLow)
        XCTAssertEqual(SoundType(tag: SoundType.singingBowlHigh.tag()), SoundType.singingBowlHigh)
        XCTAssertEqual(SoundType(tag: -1), nil)
    }
    
    func testNSSound() {
        XCTAssertNotNil(NSSound(soundType: SoundType.singingBowlLow))
        XCTAssertNil(NSSound(soundType: SoundType.silent))
    }
}
