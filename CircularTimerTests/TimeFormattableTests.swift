//
//  TimeFormattableTests.swift
//  PODTESTTests
//
//  Created by Fábio Maciel de Sousa on 17/07/20.
//  Copyright © 2020 Fábio Maciel de Sousa. All rights reserved.
//

import XCTest
@testable import CircularTimer

class TimeFormattableTests: XCTestCase {
    
    var sutHour: Hour!
    var sutMinute: Minute!
    var sutSecond: Second!


    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sutHour = Hour()
        sutMinute = Minute()
        sutSecond = Second()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sutHour = nil
        sutMinute = nil
        sutSecond = nil
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
    
    func testSecondsToString_WhenSecondsProvided_ReturnsFormattedString(){
        //Hour
        XCTAssertEqual(sutHour.secondsToString(with: 3600), "01:00:00")
        XCTAssertEqual(sutHour.secondsToString(with: -1), "")
        //Minute
        XCTAssertEqual(sutMinute.secondsToString(with: 60), "01:00")
        XCTAssertEqual(sutMinute.secondsToString(with: -1), "")
        //Second
        XCTAssertEqual(sutSecond.secondsToString(with: 1), "01")
        XCTAssertEqual(sutSecond.secondsToString(with: -1), "")
    }
    
    func testStringToSeconds_WhenTextProvided_ReturnsSeconds(){
        //Hour
        XCTAssertEqual(sutHour.stringToSeconds(from: "-01:00:00"), 0)
        XCTAssertEqual(sutHour.stringToSeconds(from: "000001"), 0)
        XCTAssertEqual(sutHour.stringToSeconds(from: "01:00"), 0)
        XCTAssertEqual(sutHour.stringToSeconds(from: "01:00:00"), 3600)
        //Minute
        XCTAssertEqual(sutMinute.stringToSeconds(from: "-01:00"), 0)
        XCTAssertEqual(sutMinute.stringToSeconds(from: "0001"), 0)
        XCTAssertEqual(sutMinute.stringToSeconds(from: "01"), 0)
        XCTAssertEqual(sutMinute.stringToSeconds(from: "01:00"), 60)
        //Second
        XCTAssertEqual(sutSecond.stringToSeconds(from: "-01"), 0)
        XCTAssertEqual(sutSecond.stringToSeconds(from: "01:00:00"), 0)
        XCTAssertEqual(sutSecond.stringToSeconds(from: "01"), 1)
    }

}
