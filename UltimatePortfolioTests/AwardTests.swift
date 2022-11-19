//
//  AwardTests.swift
//  UltimatePortfolioTests
//
//  Created by Marc Respass on 1/23/21.
//

import XCTest
import CoreData
@testable import UltimatePortfolio

private struct AwardError: Error {

}

class AwardTests: BaseTestCase {

    let awards = Award.allAwards

    func testAwardIDMatchesName() throws {
        for award in self.awards {
            XCTAssertEqual(award.id, award.id, "Award ID should always match its name.")
        }
    }

    func testUserHasZeroAwards() throws {
        for award in self.awards {
            // swiftlint:disable:next for_where
            if self.dataController.hasEarned(award: award) {
                throw AwardError()
            }
        }
    }

    func testUserHasNoAwards() throws {
        for award in self.awards {
            XCTAssertFalse(dataController.hasEarned(award: award), "new users should not have any awards!")
        }
    }

    func testAddingItems() throws {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (index, value) in values.enumerated() {
            for _ in 0..<value {
                _ = Item(context: self.moc)
            }

            let matches = awards.filter { award in
                award.criterion == "items" && dataController.hasEarned(award: award)
            }
            XCTAssertEqual(matches.count, index + 1, "Matches count should be count + 1")

            try dataController.deleteAll()
        }
    }

    func testCompletingItems() throws {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (index, value) in values.enumerated() {
            for _ in 0..<value {
                let item = Item(context: self.moc)
                item.completed = true
            }

            let matches = awards.filter { award in
                award.criterion == "complete" && dataController.hasEarned(award: award)
            }
            XCTAssertEqual(matches.count, index + 1, "Completing \(value) items should unlock \(index + 1) awards")
            
            try dataController.deleteAll()
        }
    }
}
