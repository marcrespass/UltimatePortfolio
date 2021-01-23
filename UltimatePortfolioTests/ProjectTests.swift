//
//  ProjectTests.swift
//  UltimatePortfolioTests
//
//  Created by Marc Respass on 1/23/21.
//

import XCTest
import CoreData
@testable import UltimatePortfolio

class ProjectTests: BaseTestCase {

    func testCreatingProjectsAndItems() throws {
        let targetCount = 10

        for _ in 0..<targetCount {
            let project = Project(context: self.moc)

            for _ in 0..<targetCount {
                let item = Item(context: self.moc)
                item.project = project
            }
        }

        XCTAssertEqual(self.dataController.count(for: Project.fetchRequest()), targetCount)
        XCTAssertEqual(self.dataController.count(for: Item.fetchRequest()), (targetCount * targetCount))
    }

    func testDeletingProjectCascadeDeletesItems() throws {
        try dataController.createSampleData()

        let request = NSFetchRequest<Project>(entityName: "Project")
        let projects = try self.moc.fetch(request)

        print(self.dataController.count(for: Project.fetchRequest()))
        print(self.dataController.count(for: Item.fetchRequest()))

        dataController.delete(projects[0])

        XCTAssertEqual(self.dataController.count(for: Project.fetchRequest()), 4)
        XCTAssertEqual(self.dataController.count(for: Item.fetchRequest()), 40)
    }
}
