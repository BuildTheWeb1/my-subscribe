//
//  MySubscribeUITests.swift
//  MySubscribeUITests
//
//  Created by WebSpace Developer on 15.01.2026.
//

import XCTest

final class MySubscribeUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    @MainActor
    func testHomeViewLoads() throws {
        // Verify header elements exist
        XCTAssertTrue(app.staticTexts["Total Monthly"].waitForExistence(timeout: 5))
        
        // Verify settings button exists
        let settingsButton = app.buttons["Settings"]
        XCTAssertTrue(settingsButton.exists)
        
        // Verify calendar button exists
        let calendarButton = app.buttons["View calendar"]
        XCTAssertTrue(calendarButton.exists)
        
        // Verify charts button exists
        let chartsButton = app.buttons["View spending charts"]
        XCTAssertTrue(chartsButton.exists)
        
        // Verify add button exists
        let addButton = app.buttons["Add subscription"]
        XCTAssertTrue(addButton.exists)
    }
    
    @MainActor
    func testSettingsViewOpens() throws {
        // Tap settings button
        let settingsButton = app.buttons["Settings"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()
        
        // Verify settings view elements
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 3))
        
        // Verify currency section exists
        XCTAssertTrue(app.staticTexts["Currency"].exists)
        XCTAssertTrue(app.staticTexts["Display Currency"].exists)
        
        // Verify security section exists
        XCTAssertTrue(app.staticTexts["Security"].exists)
        
        // Verify about section exists
        XCTAssertTrue(app.staticTexts["About"].exists)
        XCTAssertTrue(app.staticTexts["Version"].exists)
        
        // Close settings
        app.buttons["xmark"].tap()
    }
    
    @MainActor
    func testCalendarViewOpens() throws {
        // Tap calendar button
        let calendarButton = app.buttons["View calendar"]
        XCTAssertTrue(calendarButton.waitForExistence(timeout: 5))
        calendarButton.tap()
        
        // Verify calendar view elements
        XCTAssertTrue(app.navigationBars["Calendar"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Upcoming Renewals"].exists)
        
        // Close calendar
        app.buttons["xmark"].tap()
    }
    
    @MainActor
    func testChartsViewOpens() throws {
        // Tap charts button
        let chartsButton = app.buttons["View spending charts"]
        XCTAssertTrue(chartsButton.waitForExistence(timeout: 5))
        chartsButton.tap()
        
        // Verify charts view loads
        sleep(1)
        
        // Close charts
        app.buttons["xmark"].tap()
    }
    
    @MainActor
    func testAddSubscriptionViewOpens() throws {
        // Tap add button
        let addButton = app.buttons["Add subscription"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()
        
        // Verify add subscription view loads
        XCTAssertTrue(app.navigationBars["Add Subscription"].waitForExistence(timeout: 3))
        
        // Close add view
        app.buttons["xmark"].tap()
    }
    
    @MainActor
    func testCurrencyPickerOpens() throws {
        // Open settings
        let settingsButton = app.buttons["Settings"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()
        
        // Tap on currency selector
        let currencyButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Display Currency'")).firstMatch
        XCTAssertTrue(currencyButton.waitForExistence(timeout: 3))
        currencyButton.tap()
        
        // Verify currency picker opens
        XCTAssertTrue(app.navigationBars["Select Currency"].waitForExistence(timeout: 3))
        
        // Verify some currencies are listed
        XCTAssertTrue(app.staticTexts["USD"].exists || app.staticTexts["US Dollar"].exists)
        
        // Close currency picker
        app.buttons["xmark"].tap()
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
