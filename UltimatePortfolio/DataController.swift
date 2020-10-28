//
//  DataController.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 10/28/20.
//

import CoreData
import SwiftUI

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

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        self.container = NSPersistentCloudKitContainer(name: "Main")

        if inMemory {
            self.container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        self.container.loadPersistentStores { storeDescription, error in
            if let error = error { fatalError(error.localizedDescription) }
        }
    }

    func createSampleData() throws {
        let viewContext = self.container.viewContext

        for i in 1...5 {
            let project = Project(context: viewContext)
            project.title = "Project \(i)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()

            for j in 1...5 {
                let item = Item(context: viewContext)
                item.title = "Item \(j)"
                item.creationDate = Date()
                item.completed = Bool.random()
                item.priority = Int16.random(in: 1...3)
                item.project = project
            }
        }
        try viewContext.save()
    }
}
