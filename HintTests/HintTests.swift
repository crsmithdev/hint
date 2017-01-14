//
//  HintTests.swift
//  HintTests
//
//  Created by Christopher Smith on 12/27/16.
//  Copyright © 2016 Chris Smith. All rights reserved.
//

import XCTest
@testable import Hint

class HintTests: XCTestCase {
    
    var scheduler: Scheduler!
    
    override func setUp() {
        super.setUp()
        
        scheduler = Scheduler()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSchedule() {
        
        let expect = expectation(description: "schedule")
        scheduler.schedule(1, block: { () -> Void in
            expect.fulfill()
        })
        
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
        }
    }
}
