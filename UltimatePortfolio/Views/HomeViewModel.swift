//
//  HomeViewModel.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 5/3/21.
//

import CoreData
import Foundation

extension HomeView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let projectsController: NSFetchedResultsController<Project>
        private let itemsController: NSFetchedResultsController<Item>
        var dataController: DataController

        @Published var projects: [Project] = []
        @Published var items: [Item] = []
        @Published var selectedItem: Item?
        @Published var upNext: ArraySlice<Item> = []
        @Published var moreToExplore: ArraySlice<Item> = []

        init(dataController: DataController) {
            self.dataController = dataController

            // Construct a fetch request to show all open projects
            let projectRequest: NSFetchRequest<Project> = Project.fetchRequest()
            projectRequest.predicate = NSPredicate(format: "closed = false")
            projectRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]

            self.projectsController = NSFetchedResultsController(fetchRequest: projectRequest,
                                                                 managedObjectContext: dataController.container.viewContext,
                                                                 sectionNameKeyPath: nil,
                                                                 cacheName: nil)

            let itemRequest = dataController.fetchRequestForTopItems(count: 10)
            self.itemsController = NSFetchedResultsController(fetchRequest: itemRequest,
                                                              managedObjectContext: dataController.container.viewContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)

            super.init()

            self.projectsController.delegate = self
            self.itemsController.delegate = self

            do {
                try self.projectsController.performFetch()
                try self.itemsController.performFetch()
                self.projects = self.projectsController.fetchedObjects ?? []
                self.items = self.itemsController.fetchedObjects ?? []

                upNext = items.prefix(3)
                moreToExplore = items.dropFirst(3)
            } catch {
                print("Failed to fetch initial data")
            }
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            // is controller one of self.projectsController or self.itemsController?
            if controller == self.itemsController {
                debugPrint("CHANGING ITEMS")
                self.items = controller.fetchedObjects as? [Item] ?? []
                upNext = items.prefix(3)
                moreToExplore = items.dropFirst(3)
            }
            if controller == self.projectsController {
                debugPrint("CHANGING PROJECTS")
                self.projects = controller.fetchedObjects as? [Project] ?? []
            }
        }

        func deleteAllData() {
           try? self.dataController.deleteAll()
        }

        func addSampleData() {
            self.deleteAllData()
            try? self.dataController.createSampleData()
        }

        func selectItem(with identifier: String) {
            self.selectedItem = self.dataController.item(with: identifier)
        }
    }
}
