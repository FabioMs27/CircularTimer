//
//  TimeTrackerTests.swift
//  PODTESTTests
//
//  Created by Fábio Maciel de Sousa on 18/07/20.
//  Copyright © 2020 Fábio Maciel de Sousa. All rights reserved.
//

import XCTest
@testable import CircularTimer

class TimeTrackerTests: XCTestCase {
    
    var sut: TimeTracker!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = TimeTracker()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testStartTimer_WhenCalled_StartCountDownAndUpdateView(){
        let expectation = self.expectation(description: "Timer")
        
        sut.defaultTime = 2
        sut.configTime = 2
        sut.countDown = 5
        sut.timerFormatDelegate = Hour()
        sut.stopTimer {}
        XCTAssertFalse(sut.timer.isValid)
        sut.startTimer { (_, _) in}
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertFalse(self.sut.timer.isValid)
            expectation.fulfill()
        }
        XCTAssert(sut.timer.isValid)
        
        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func testCountDown_WhenValeuDecreasedToZero_EndTimer(){
        sut.countDown = 10
        sut.hasEnded = false
        sut.countDown = 0
        XCTAssert(sut.hasEnded)
    }
}
