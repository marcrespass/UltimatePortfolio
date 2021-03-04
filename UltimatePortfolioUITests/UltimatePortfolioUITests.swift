//
//  UltimatePortfolioUITests.swift
//  UltimatePortfolioUITests
//
//  Created by Marc Respass on 3/4/21.
//

import XCTest

class UltimatePortfolioUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()

    }

    func testAppHasFourTabs() throws {
        XCTAssertEqual(app.tabBars.buttons.count, 4, "There should be 4 tabs in the app")
    }

    func testTapOpenButtonShowsZeroRows() throws {
        app.buttons["Open"].tap()
        let initialRows = app.tables.cells.count
        XCTAssertEqual(initialRows, 0, "There should not be any projects initially")
    }

    func testOpenTabAndTapAddButton() throws {
        app.buttons["Open"].tap()
        let initialRows = app.tables.cells.count
        XCTAssertEqual(initialRows, 0, "There should not be any projects initially")

        for tapCount in 1...5 {
            app.buttons["add"].tap()
            let updatedRows = app.tables.cells.count
            XCTAssertEqual(updatedRows, tapCount, "There should be \(tapCount) projects")
            print("***\nNumber of projects:\(updatedRows)\n***")
        }
    }

    func tapOpenAddProjectAddItemAndAssert() {
        app.buttons["Open"].tap()
        let initialRows = app.tables.cells.count
        XCTAssertEqual(initialRows, 0, "There should not be any projects initially")

        app.buttons["add"].tap()
        var updatedRows = app.tables.cells.count
        XCTAssertEqual(updatedRows, 1, "There should be 1 row after adding a project")

        app.buttons["Add new item"].tap()
        updatedRows = app.tables.cells.count
        XCTAssertEqual(updatedRows, 2, "There should be 2 list rows after adding an item")
    }

    func testAddingItemInsertsRows() throws {
        self.tapOpenAddProjectAddItemAndAssert()
    }

    func testEditingProjectUpdatesCorrectly() {
        app.buttons["Open"].tap()
        let initialRows = app.tables.cells.count
        XCTAssertEqual(initialRows, 0, "There should not be any projects initially")

        app.buttons["add"].tap()
        let updatedRows = app.tables.cells.count
        XCTAssertEqual(updatedRows, 1, "There should be 1 row after adding a project")

        app.buttons["NEW PROJECT"].tap()
        app.textFields["Project name"].tap()

        // NB: This will only work if the software keyboard is showing in Simulator
        app.keys["space"].tap()
        app.keys["more"].tap()
        app.keys["2"].tap()
        app.buttons["Return"].tap()

        app.buttons["Open Projects"].tap()
        XCTAssertTrue(app.buttons["NEW PROJECT 2"].exists)
    }

    func testEditingItemUpdatesCorrectly() {
        self.tapOpenAddProjectAddItemAndAssert()

        app.buttons["New Item"].tap()
        app.textFields["Item name"].tap()

        // NB: This will only work if the software keyboard is showing in Simulator
        app.keys["space"].tap()
        app.keys["more"].tap()
        app.keys["2"].tap()
        app.buttons["Return"].tap()

        app.buttons["Open Projects"].tap()
        XCTAssertTrue(app.buttons["New Item 2"].exists, "The new item should be visible.")
    }
}
