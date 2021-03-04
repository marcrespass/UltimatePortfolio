//
//  PerformanceTests.swift
//  UltimatePortfolioTests
//
//  Created by Marc Respass on 2/25/21.
//

import XCTest
import CoreData
@testable import UltimatePortfolio

class PerformanceTests: BaseTestCase {

    func testAwardCalculationPerformance() throws {
        for _ in 1...100 {
            try dataController.createSampleData()
        }

        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        let comment = "This checks the number of awards is constant. Change this if you add new awards"
        XCTAssertEqual(awards.count, 500, comment)

        self.measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }

}
