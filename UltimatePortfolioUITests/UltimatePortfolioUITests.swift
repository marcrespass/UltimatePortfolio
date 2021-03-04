//
//  UltimatePortfolioUITests.swift
//  UltimatePortfolioUITests
//
//  Created by Marc Respass on 3/4/21.
//

import XCTest

class UltimatePortfolioUITests: XCTestCase {

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    func testAppHasFourTabs() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()

        XCTAssertEqual(app.tabBars.buttons.count, 4, "There should be 4 tabs in the app")
    }
}
