//
//  SharedProjectView.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 8/10/21.
//

import CloudKit
import SwiftUI

struct SharedProjectView: View {
    static let tag: String? = "Community"

    @State private var projects: [SharedProject] = []
    @State private var loadState = LoadState.inactive

    var body: some View {
        NavigationView {
            Group {
                switch loadState {
                case .inactive, .loading:
                    ProgressView()
                case .noResults:
                    Text("No Results")
                case .success:
                    List(projects) { project in
                        NavigationLink(destination: SharedItemsView(project: project)) {
                            VStack(alignment: .leading) {
                                Text(project.title)
                                    .font(.headline)

                                Text(project.owner)
                            }
                        }
                    }
                        .listStyle(InsetGroupedListStyle())
                }
            }
                .navigationTitle("Shared projects")
        }
            .onAppear(perform: fetchSharedProjects)
    }

    func fetchSharedProjects() {
        guard loadState == .inactive else { return }
        loadState = .loading

        let predicate = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: "Project", predicate: predicate)
        query.sortDescriptors = [sort]

        let operation = CKQueryOperation(query: query)
        // If you don't set desiredKeys then you get all fields
        // Paul prefers to be specific and so do I
        operation.desiredKeys = ["title", "detail", "owner", "close"]
        operation.resultsLimit = 50

        // Next we’re going to provide the first of two closures that CloudKit will run when evens happen.
        // This one is recordFetchedBlock, and it will be called once for each record downloaded
        // by CloudKit as a result of our query.
        // This is where the conversion from CKRecord to SharedProject happens,
        // which means we’re going to read the key strings out of our CKRecord,
        // provide meaningful defaults for missing values,
        // then create a new SharedProject instance from that and add it to the projects array.
        operation.recordFetchedBlock = { record in
            let sharedProject = SharedProject(ckRecord: record)
            projects.append(sharedProject)
            loadState = .success
        }

        // queryCompletionBlock returns an optional cursor and error which we will ignore
        operation.queryCompletionBlock = { _, _ in
            if projects.isEmpty {
                loadState = .noResults
            }
        }

        CKContainer.default().publicCloudDatabase.add(operation)
    }
}

struct SharedProjectView_Previews: PreviewProvider {
    static var previews: some View {
        SharedProjectView()
    }
}
