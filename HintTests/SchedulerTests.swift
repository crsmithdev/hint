//
//  SchedulerTests.swift
//  HintTests
//
//  Created by Christopher Smith on 12/27/16.
//  Copyright © 2016 Chris Smith. All rights reserved.
//

import XCTest
@testable import Hint

class SchedulerTests: XCTestCase {
    
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
        
        XCTAssert(scheduler.interval == 1)
        
        waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
    
    func testPauseResume() {
        
        let expect = expectation(description: "schedule")
        scheduler.schedule(1, block: { () -> Void in
            expect.fulfill()
        })
        scheduler.pause()
        XCTAssert(scheduler.paused)
        scheduler.resume()
        XCTAssert(!scheduler.paused)

        waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
    }
}
