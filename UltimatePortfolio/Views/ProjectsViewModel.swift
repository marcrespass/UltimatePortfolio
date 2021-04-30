//
//  ProjectsViewModel.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 4/30/21.
//

import CoreData
import Foundation
import SwiftUI

extension ProjectsView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        let dataController: DataController

        var sortOrder = Item.SortOrder.optimized
        let showClosedProjects: Bool

        private let projectsController: NSFetchedResultsController<Project>
        @Published var projects: [Project] = []

        init(dataController: DataController, showClosedProjects: Bool) {
            self.showClosedProjects = showClosedProjects
            self.dataController = dataController

            let request: NSFetchRequest<Project> = Project.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)]
            request.predicate = NSPredicate(format: "closed = %d", showClosedProjects)

            self.projectsController = NSFetchedResultsController(fetchRequest: request,
                                                                 managedObjectContext: dataController.container.viewContext,
                                                                 sectionNameKeyPath: nil,
                                                                 cacheName: nil)
            super.init()
            self.projectsController.delegate = self
            do {
                try self.projectsController.performFetch()
                self.projects = self.projectsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch our projects")
                print("\(error)")
            }
        }

        func addItem(to project: Project) {
            let item = Item(context: self.dataController.container.viewContext)
            item.project = project
            item.creationDate = Date()
            dataController.save()
        }

        func addProject() {
            let project = Project(context: self.dataController.container.viewContext)
            project.closed = false
            project.creationDate = Date()
            dataController.save()
        }

        func delete(_ indexSet: IndexSet, project: Project) {
            let allItems = project.projectItems(using: self.sortOrder)

            for offset in indexSet {
                debugPrint("Deleting \(offset)")
                let item = allItems[offset]
                dataController.delete(item)
            }

            dataController.save()
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newProjects = controller.fetchedObjects as? [Project] {
                self.projects = newProjects
            }
        }
    }
}
