//
//  DataController.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 10/28/20.
//

import SwiftUI
import CoreData
import CoreSpotlight
import WidgetKit

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

    // The UserDefaults suite where we're saving user data.
    let defaults: UserDefaults

    // Loads and saves whether our premium unlock has been purchased.
    var fullVersionUnlocked: Bool {
        get {
            defaults.bool(forKey: "fullVersionUnlocked")
        }

        set {
            defaults.set(newValue, forKey: "fullVersionUnlocked")
        }
    }
    /// The lone CloudKit container used to store all our data.
    let container: NSPersistentCloudKitContainer

    /// Initializes a data controller, either in memory (for temporary use such as testing and previewing),
    /// or on permanent storage (for use in regular app runs.) Defaults to permanent storage.
    ///
    /// Defaults to permanent storage
    /// - Parameter inMemory: Whether to store this data in temporary memory or not.
    // MARK: - Init
    init(inMemory: Bool = false, defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)

        if inMemory {
            self.container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let groupID = "group.com.iliosinc.ultimateportfolio"

            if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) {
                container.persistentStoreDescriptions.first?.url = url.appendingPathComponent("Main.sqlite")
            }
        }

        self.container.loadPersistentStores { _, error in
            if let error = error { fatalError(error.localizedDescription) }
        }

        // Needed for iCloud to update immediately
        self.container.viewContext.automaticallyMergesChangesFromParent = true

        #if DEBUG
        if CommandLine.arguments.contains("enable-testing") {
            print("enable-testing is set.")
            try? self.deleteAll()
            #if os(iOS)
            UIView.setAnimationsEnabled(false)
            #endif
        }
        #endif

    }

    /// Saves our Core Data context iff (if and only if) there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because all our attributes are optional.
    func save() {
        if self.container.viewContext.hasChanges {
            do {
                try self.container.viewContext.save()
                WidgetCenter.shared.reloadAllTimelines()
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }

    func delete(_ object: Item) {
        let moID = object.objectID.uriRepresentation().absoluteString
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [moID])
        self.container.viewContext.delete(object)
    }

    func delete(_ object: Project) {
        let moID = object.objectID.uriRepresentation().absoluteString
        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [moID])
        self.container.viewContext.delete(object)
    }

    @discardableResult func addProject() -> Bool {
        let canCreate = self.fullVersionUnlocked || self.count(for: Project.fetchRequest()) < 3

        if canCreate {
            let project = Project(context: self.self.container.viewContext)
            project.closed = false
            project.creationDate = Date()
            self.save()
            return true
        } else {
            return false
        }
    }
}

// MARK: - Helpers
extension DataController {
    func fetchRequestForTopItems(count: Int) -> NSFetchRequest<Item> {
        // Construct a fetch request to show all 10 highest priority items from open projects
        let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()

        let completedPredicate = NSPredicate(format: "completed = false")
        let openPredicate = NSPredicate(format: "project.closed = false")
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])

        itemRequest.predicate = compoundPredicate
        itemRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Item.priority, ascending: false)
        ]

        itemRequest.fetchLimit = count
        return itemRequest
    }

    func results<T: NSManagedObject>(for fetchRequest: NSFetchRequest<T>) -> [T] {
        return (try? container.viewContext.fetch(fetchRequest)) ?? []
    }

    func deleteAll() throws {
        // TODO: ¿Delete all spotlight data?
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        self.delete(fetchRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        self.delete(fetchRequest2)
    }

    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: (delete.result as? [NSManagedObjectID]) ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    /// Creates example projects and items to make manual testing easier.
    /// - Throws: An NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData() throws {
        let viewContext = self.container.viewContext

        for index1 in 1...3 {
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

// MARK: - Core Spotlight
extension DataController {
    func update(_ item: Item) {
        let itemID = item.objectID.uriRepresentation().absoluteString
        let projectID = item.project?.objectID.uriRepresentation().absoluteString

        let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        attributeSet.title = item.itemTitle
        attributeSet.contentDescription = item.itemDetail

        let searchableItem = CSSearchableItem(
            uniqueIdentifier: itemID,
            domainIdentifier: projectID,
            attributeSet: attributeSet
        )

        CSSearchableIndex.default().indexSearchableItems([searchableItem])

        self.save()
    }

    func item(with uniqueIdentifier: String) -> Item? {
        guard let url = URL(string: uniqueIdentifier),
              let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else { return nil }

        let item = try? container.viewContext.existingObject(with: id) as? Item
        return item
    }
}
