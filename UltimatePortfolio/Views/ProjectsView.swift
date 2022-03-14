//
//  ProjectsView.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 10/29/20.
//

import SwiftUI

struct ProjectsView: View {
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"

    @StateObject var viewModel: ViewModel
    @State private var showingSortOrder = false

    init(dataController: DataController, showCloseProjects: Bool) {
        let viewModel = ViewModel(dataController: dataController, showClosedProjects: showCloseProjects)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    func openURL(_ url: URL) {
        viewModel.addProject()
    }

    var projectsListView: some View {
        List {
            ForEach(viewModel.projects) { project in
                Section(header: ProjectHeaderView(project: project)) {
                    ForEach(project.projectItems(using: self.viewModel.sortOrder)) { item in
                        ItemRowView(project: project, item: item)
                    }
                    .onDelete { indexSet in
                        self.viewModel.delete(indexSet, project: project)
                    }
                    if viewModel.showClosedProjects == false {
                        Button {
                            withAnimation {
                                self.viewModel.addItem(to: project)
                            }
                        } label: {
                            Label("Add new item", systemImage: "plus")
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }

    var addProjectToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            if viewModel.showClosedProjects == false {
                Button {
                    withAnimation {
                        self.viewModel.addProject()
                    }
                } label: {
                    Label("Add Project", systemImage: "plus")
                }
            }
        }
    }

    var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Menu {
                Button("Optimized") { viewModel.sortOrder = .optimized }
                Button("Creation Date") { viewModel.sortOrder = .creationDate }
                Button("Title") { viewModel.sortOrder = .title }
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.projects.isEmpty {
                    Text("There's nothing here right now.")
                        .foregroundColor(.secondary)
                } else {
                    projectsListView
                }
            }
            .navigationTitle(viewModel.showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                addProjectToolbarItem
                sortOrderToolbarItem
            }

            SelectSomethingView()
        }
        .sheet(isPresented: $viewModel.showingUnlockView) {
            UnlockView()
        }
//        .onOpenURL(perform: openURL) // This only works if this tab is already selected
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView(dataController: DataController.preview, showCloseProjects: false)
    }
}
