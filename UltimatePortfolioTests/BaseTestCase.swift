//
//  UltimatePortfolioTests.swift
//  UltimatePortfolioTests
//
//  Created by Marc Respass on 1/18/21.
//

import XCTest
import CoreData
@testable import UltimatePortfolio

// command-option-control-G Test Again
class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!

    override func setUpWithError() throws {
        self.dataController = DataController(inMemory: true)
        self.moc = dataController.container.viewContext
    }
}
