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

        @Published var projects: [Project] = []
        @Published var items: [Item] = []

        var dataController: DataController

        var upNext: ArraySlice<Item> {
            items.prefix(3)
        }

        var moreToExplore: ArraySlice<Item> {
            items.dropFirst(3)
        }

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

            // Construct a fetch request to show all 10 highest priority items from open projects
            let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()

            let completedPredicate = NSPredicate(format: "completed = false")
            let openPredicate = NSPredicate(format: "project.closed = false")
            let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])

            itemRequest.predicate = compoundPredicate
            itemRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \Item.priority, ascending: false)
            ]

            itemRequest.fetchLimit = 10
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
            } catch {
                print("Failed to fetch initial data")
            }
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            // is controller one of self.projectsController or self.itemsController?
            if controller == self.itemsController, let newItems = controller.fetchedObjects as? [Item] {
                self.items = newItems
            }
            if controller == self.projectsController, let newProjects = controller.fetchedObjects as? [Project] {
                self.projects = newProjects
            }
        }

        func addSampleData() {
            self.dataController.deleteAll()
            try? self.dataController.createSampleData()
        }
    }
}
