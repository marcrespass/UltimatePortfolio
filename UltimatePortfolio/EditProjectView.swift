//
//  EditProjectView.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 11/9/20.
//

import SwiftUI

struct EditProjectView: View {
    let project: Project

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm = false

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(project: Project) {
        self.project = project

        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)
    }

    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Project name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
            }
            Section(header: Text("Custom project color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self) { item in
                        ZStack {
                            Color(item)
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(6)

                            if item == color {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                            }
                        }
                        .onTapGesture {
                            color = item
                            update()
                        }
                    }
                }
                .padding(.vertical)
            }
            Section(footer: Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project entirely.")) {
                Button(project.closed ? "Reopen this project" : "Close this project") {
                    self.project.closed.toggle()
                    self.update()
                }

                Button("Delete this project") {
                    self.showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
        }
        .navigationTitle("Edit Project")
        .onDisappear(perform: self.dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(title: Text("Delete project?"),
                  message: Text("Are you sure?"),
                  primaryButton: .default(Text("Delete")), secondaryButton: .cancel())
        }
    }

    func update() {
        self.project.title = self.title
        self.project.detail = self.detail
        self.project.color = self.color
    }

    func delete() {
        self.dataController.delete(self.project)
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}
