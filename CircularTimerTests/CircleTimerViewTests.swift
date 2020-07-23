//
//  CircleTimerViewTests.swift
//  PODTESTTests
//
//  Created by Fábio Maciel de Sousa on 17/07/20.
//  Copyright © 2020 Fábio Maciel de Sousa. All rights reserved.
//

import XCTest
@testable import CircularTimer

class CircleTimerViewTests: XCTestCase {
    
    var sut: CircleTimerView!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = CircleTimerView()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        sut = nil
    }

    //MARK: - Methods
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
    
    func testWillMove_WhenViewIsPresented_SetTimerToDefaultValue(){
        sut.setTimerValue(0)
        sut.willMove(toSuperview: nil)
        XCTAssertEqual(sut.timeTracker.defaultTime, 60)
        XCTAssertEqual(sut.timeTracker.configTime, 60)
    }
    
    func testAnimateRing_WhenTimerStarts_StartAnimation(){
        //if no animation is happening
        sut.isRunning = false
        sut.animateRing(FromStroke: 0, FromAngle: 0, To: 1)
        XCTAssert(sut.isRunning)
        XCTAssertNotEqual(sut.ringLayer.animation(forKey: "animateRing"), nil)
        XCTAssertNotEqual(sut.pinLayer.animation(forKey: "animatePin"), nil)
        
        //if there is already an animation
        sut.ringLayer.removeAllAnimations()
        sut.pinLayer.removeAllAnimations()
        sut.isRunning = true
        sut.animateRing(FromStroke: 0, FromAngle: 0, To: 1)
        XCTAssertEqual(sut.ringLayer.animation(forKey: "animateRing"), nil)
        XCTAssertEqual(sut.pinLayer.animation(forKey: "animatePin"), nil)
    }
    
    func testLayoutSubViews_WhenCalled_DelegateMustBeValid(){
        sut.setTimerValue(10)
        sut.layoutSubviews()
        XCTAssertNotNil(sut.timeTracker.timerFormatDelegate)
        sut.timeTracker.timerFormatDelegate = nil
        sut.timerLabel.text = nil
        sut.layoutSubviews()
        XCTAssertNil(sut.timerLabel.text)
    }
    
    func testRemoveAnimation_WhenAnimationHasStopped_Reset(){
        sut.removeAnimation()
        sut.animateRing(FromStroke: 0, FromAngle: 0, To: 1)
        sut.removeAnimation()
        XCTAssertFalse(sut.isRunning)
        XCTAssertEqual(sut.ringLayer.animation(forKey: "animateRing"), nil)
        XCTAssertEqual(sut.pinLayer.animation(forKey: "animatePin"), nil)
    }

    func testSetTimerValue_WhenValueProvided_SetTimer(){
        //Check if values changed
        sut.timeTracker.configTime = 0
        sut.timeTracker.defaultTime = 0
        sut.setTimerValue(10)
        XCTAssertEqual(sut.timeTracker.configTime, 10)
        XCTAssertEqual(sut.timeTracker.defaultTime, 10)
        //Check if its format is second
        XCTAssertNotNil(sut.timeTracker.timerFormatDelegate as? Second)
        //Check if the format is minutes
        sut.setTimerValue(60)
        XCTAssertNotNil(sut.timeTracker.timerFormatDelegate as? Minute)
        //Check if the format is hour
        sut.setTimerValue(3600)
        XCTAssertNotNil(sut.timeTracker.timerFormatDelegate as? Hour)
    }
    
    func testIsValid_WhenCheckingTimer_ReturnBoolean(){
        sut.stopTimer()
        XCTAssertFalse(sut.isValid)
        sut.timeTracker.timer = Timer.scheduledTimer(withTimeInterval: 100, repeats: false, block: { (_) in
            
        })
        XCTAssertTrue(sut.isValid)
    }
    
    func testStartTimer_WhenCalled_UpdateView(){
        //Set expectation to when thread is over
        let expectation = self.expectation(description: "Timer")
        //Set timer values for test
        sut.isRunning = false
        sut.setTimerValue(2)
        sut.timeTracker.defaultTime = 1
        sut.startTimer()
        XCTAssertEqual(self.sut.timeTracker.configTime, self.sut.timeTracker.defaultTime)
        //Test if text is running properly (It starts at "02" and after 1 second it turns to "01")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.sut.timerLabel.text, "01")
        }
        //Test when timer has ended
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertFalse(self.sut.isRunning)
            //Test if timer is already running
            self.sut.stopTimer()
            self.sut.isRunning = true
            self.sut.layer.speed = 0.0
            self.sut.layer.timeOffset = 1.0
            self.sut.startTimer()
            XCTAssertEqual(self.sut.layer.speed, 1.0)
            XCTAssertEqual(self.sut.layer.timeOffset, 0.0)
            //End tests
            expectation.fulfill()
        }
        //Wait for tests to finish
        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func testStopTimer_WhenTimerEnds_ResetTimerAndAnimation(){
        sut.timeTracker.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { (_) in
            
        })
        sut.timeTracker.configTime = 0
        sut.timeTracker.defaultTime = 10
        sut.animateRing(FromStroke: 0, FromAngle: 0, To: 1)
        sut.stopTimer()
        XCTAssertEqual(sut.timeTracker.configTime, sut.timeTracker.defaultTime)
        XCTAssertFalse(sut.isValid)
        XCTAssertNil(sut.ringLayer.animation(forKey: "animateRing"))
        XCTAssertNil(sut.pinLayer.animation(forKey: "animatePin"))
    }
    
    func testPauseTimer_WhenCalled_PauseTimerAndAnimation(){
        sut.setTimerValue(60)
        sut.layer.speed = 1
        sut.timeTracker.countDown = 5
        sut.startTimer()
        sut.pauseTimer()
        XCTAssertEqual(sut.timeTracker.configTime, sut.timeTracker.countDown)
        XCTAssertFalse(sut.isValid)
        XCTAssertEqual(sut.layer.speed, 0.0)
    }
    
    func testRemoveAnimation_WhenTimerEnds_RemoveAllAnimatinos(){
        sut.animateRing(FromStroke: 0, FromAngle: 0, To: 1)
        sut.removeAnimation()
        XCTAssertNil(sut.ringLayer.animation(forKey: "animateRing"))
        XCTAssertNil(sut.pinLayer.animation(forKey: "animatePin"))
    }
    
    func testEnterBackground_WhenInBackground_GetCurrentTime(){
        sut.wentToBackground = false
        sut.totalTime = 0
        sut.enterBackground()
        XCTAssertEqual(Int(sut.date.distance(to: Date())), 0)
        XCTAssert(sut.wentToBackground)
        XCTAssertEqual(sut.totalTime, CGFloat(sut.timeTracker.defaultTime))
    }
    
    func testEnterForeground_WhenInForeground_GetDistanceBetweenDates(){
        sut.wentToBackground = true
        sut.isRunning = true
        sut.timeTracker.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (_) in
            
        })
        sut.date = Date()
        sut.timeTracker.countDown = 0
        sut.enterForeground()
        XCTAssertFalse(sut.wentToBackground)
        XCTAssert(sut.isRunning)
        XCTAssertEqual(sut.timeTracker.countDown, 0)
        sut.isRunning = true
        sut.wentToBackground = true
        sut.layer.speed = 0.0
        sut.enterForeground()
        XCTAssertEqual(sut.layer.timeOffset, 0.0)
        sut.stopTimer()
    }
    
    func testCalculateStartingPoint_WhenValuesProvided_SetWhereAnimationShouldStart(){
        sut.totalTime = 10
        XCTAssertEqual(sut.calculateStartingPoint(By: 2, To: 1), 0.8)
        XCTAssertEqual(sut.calculateStartingPoint(By: 0, To: 1), 1)
    }
    
    //MARK: - Designable
    func testDesignableExtension_WhenValuesGot_ReturnDefaultValue(){
        //fontSize
        XCTAssertEqual(sut.fontSize, 32.0)
        sut.fontSize = 6
        XCTAssertEqual(sut.timerLabel.font.pointSize, 6)
        //enableTimer
        XCTAssertEqual(sut.enableTimer, true)
        sut.enableTimer = false
        XCTAssert(sut.timerLabel.isHidden)
        //fontColor
        sut.fontColor = UIColor.black
        XCTAssertEqual(sut.fontColor, sut.timerLabel.textColor)
        XCTAssertEqual(sut.timerLabel.textColor, UIColor.black)
        //canAdaptTimer
        XCTAssertEqual(sut.canAdaptTimer, true)
        sut.canAdaptTimer = false
        XCTAssertEqual(sut.canAdaptTimerFormat, false)
        XCTAssertNotNil(sut.timeTracker.timerFormatDelegate as? Hour)
        //backgrounddCircleRadius
        XCTAssertEqual(sut.backgroundCircleRadius, 0.0)
        sut.backgroundCircleRadius = 10
        let radius = (min(sut.frame.size.width, sut.frame.size.height) - sut.ringStrokeWidth - 2)/2
        
        let circlebackgroundRadius = (10*radius)/90
        
        let circleBackgroundPath = CGPath(ellipseIn: CGRect(x: -CGFloat(circlebackgroundRadius), y: -CGFloat(circlebackgroundRadius), width: CGFloat(2 * circlebackgroundRadius), height: CGFloat(2 * circlebackgroundRadius)), transform: nil)
        XCTAssertEqual(sut.circleBackgroundLayer.path, circleBackgroundPath)
        //backgroundCircleColor
        sut.backgroundCircleColor = .black
        XCTAssertEqual(sut.backgroundCircleColor, UIColor.init(cgColor: sut.circleBackgroundLayer.fillColor!))
        XCTAssertEqual(sut.circleBackgroundLayer.fillColor, UIColor.black.cgColor)
        //stroke
        XCTAssertEqual(sut.stroke, 0.0)
        sut.stroke = 10
        XCTAssertEqual(sut.proportion, 0.1)
        //strokeWidth
        XCTAssertEqual(sut.strokeWidth, 0.0)
        sut.strokeWidth = 10
        XCTAssertEqual(sut.circleStrokeWidth, 10)
        //completedStrokeWidth
        XCTAssertEqual(sut.completedStrokeWidth, 0.0)
        sut.completedStrokeWidth = 10
        XCTAssertEqual(sut.ringStrokeWidth, 10)
        //strokeColor
        sut.circleLayer.fillColor = UIColor.black.cgColor
        XCTAssertEqual(sut.strokeColor, UIColor.black)
        sut.strokeColor = UIColor.black
        XCTAssertEqual(sut.circleLayer.strokeColor, UIColor.black.cgColor)
        //completedStrokeColor
        sut.ringLayer.fillColor = UIColor.black.cgColor
        XCTAssertEqual(sut.completedStrokeColor, UIColor.black)
        sut.completedStrokeColor = UIColor.black
        XCTAssertEqual(sut.ringLayer.strokeColor, UIColor.black.cgColor)
        //pinColor
        sut.pinLayer.fillColor = UIColor.black.cgColor
        XCTAssertEqual(sut.pinColor, UIColor.black)
        sut.pinColor = UIColor.black
        XCTAssertEqual(sut.pinLayer.fillColor, UIColor.black.cgColor)
        //pinRadius
        XCTAssertEqual(sut.pinRadius, 7)
        sut.pinRadius = 10
        let pinRadius = (min(sut.frame.size.width, sut.frame.size.height) - sut.ringStrokeWidth - 2)/2
        let pinPath = CGPath(ellipseIn: CGRect(x: -10, y: CGFloat(Int(-pinRadius)) - 10, width: 2 * 10, height: 2 * 10), transform: nil)
        XCTAssertEqual(sut.pinLayer.path, pinPath)
    }
}
