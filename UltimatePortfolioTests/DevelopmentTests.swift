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
        dataController.deleteAll()

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 0, "Expected 0 projects")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 0, "Expected 0 items")
    }

}
