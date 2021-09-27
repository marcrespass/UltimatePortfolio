//
//  DevelopmentTests.swift
//  UltimatePortfolioTests
//
//  Created by Marc Respass on 2/3/21.
//

import XCTest
import CoreData
@testable import UltimatePortfolio

class DevelopmentTests: BaseTestCase {

    func testSampleDataCreationWorks() throws {
        try dataController.createSampleData()

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 5, "Expected 5 projects")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 50, "Expected 50 items")
    }

    func testDeleteAllClearsEverything() throws {
        try dataController.createSampleData()
        try dataController.deleteAll()

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 0, "Expected 0 projects")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 0, "Expected 0 items")
    }

    func testExampleProjectIsClosed() {
        let project = Project.example
        XCTAssertTrue(project.closed, "project should be closed")
    }

    func testExampleItemIsHighPriority() {
        let item = Item.example
        XCTAssertTrue(item.priority == 3, "item should be high priority")
    }
}
