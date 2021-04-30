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
    class ViewModel: ObservableObject {
        let dataController: DataController
        var sortOrder = Item.SortOrder.optimized
        let showClosedProjects: Bool
        let projects: FetchRequest<Project>

        init(dataController: DataController, showClosedProjects: Bool) {
            self.showClosedProjects = showClosedProjects
            self.dataController = dataController

            projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [
                NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
            ], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
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

    }
}
