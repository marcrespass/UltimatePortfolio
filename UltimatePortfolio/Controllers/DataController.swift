//
//  DataController.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 10/28/20.
//

import CoreData
import SwiftUI

/// An environment singleton responsible for managing our Core Data stack, including handling saving,
/// counting fetch requests, tracking awards, and dealing with sample data.
public final class DataController: ObservableObject {
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }

        return dataController
    }()

    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError()
        }

        guard let mom = NSManagedObjectModel(contentsOf: url) else {
            fatalError()
        }

        return mom
    }()

    /// The lone CloudKit container used to store all our data.
    let container: NSPersistentCloudKitContainer

    /// Initializes a data controller, either in memory (for temporary use such as testing and previewing),
    /// or on permanent storage (for use in regular app runs.) Defaults to permanent storage.
    ///
    /// Defaults to permanent storage
    /// - Parameter inMemory: Whether to store this data in temporary memory or not.
    init(inMemory: Bool = false) {
        self.container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)

        if inMemory {
            self.container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        self.container.loadPersistentStores { _, error in
            if let error = error { fatalError(error.localizedDescription) }
        }

        // If we are debugging and not unit testing
        // NB: UITests do not add XCTestSessionIdentifier
        if ProcessInfo.processInfo.isDebugNotTesting() {
            self.deleteAll()
            try? self.createSampleData()
        }

        #if DEBUG
        if CommandLine.arguments.contains("enable-testing") {
            print("CommandLine has this.")
            self.deleteAll()
        }
        #endif

    }

    /// Saves our Core Data context iff (if and only if) there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because all our attributes are optional.
    func save() {
        if self.container.viewContext.hasChanges {
            do {
                try self.container.viewContext.save()
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }

    func delete(_ object: NSManagedObject) {
        self.container.viewContext.delete(object)
    }
}

extension DataController {

    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
            case "items":
                let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
                let awardCount = count(for: fetchRequest)
                return awardCount >= award.value
            case "complete":
                let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
                fetchRequest.predicate = NSPredicate(format: "completed = true")
                let awardCount = count(for: fetchRequest)
                return awardCount >= award.value
            default:
                // fatalError("Unknown award criterion \(award.criterion).")
                return false
        }
    }

    /// Creates example projects and items to make manual testing easier.
    /// - Throws: An NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData() throws {
        let viewContext = self.container.viewContext

        for index1 in 1...5 {
            let project = Project(context: viewContext)
            project.title = "Project \(index1)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()

            for index2 in 1...10 {
                let item = Item(context: viewContext)
                item.title = "Item \(index2)"
                item.creationDate = Date()
                item.completed = Bool.random()
                item.priority = Int16.random(in: 1...3)
                item.project = project
            }
        }
        try viewContext.save()
    }
}
