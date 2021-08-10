//
//  SharedItemsView.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 8/10/21.
//

import CloudKit
import SwiftUI

struct SharedItemsView: View {
    let project: SharedProject

    @State private var items = [SharedItem]()
    @State private var itemsLoadState = LoadState.inactive

    var body: some View {
        List {
            Section {
                switch itemsLoadState {
                case .inactive, .loading:
                    ProgressView()
                case .noResults:
                    Text("No results")
                case .success:
                    ForEach(items) { item in
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)

                            if item.detail.isEmpty == false {
                                Text(item.detail)
                            }
                        }
                    }
                }
            }
        }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(project.title)
            .onAppear {
                fetchSharedItems()
            }
    }

    func fetchSharedItems() {
        guard itemsLoadState == .inactive else { return }
        itemsLoadState = .loading

        let recordID = CKRecord.ID(recordName: project.id)
        let reference = CKRecord.Reference(recordID: recordID, action: .none)
        let predicate = NSPredicate(format: "project == %@", reference)

        let sort = NSSortDescriptor(key: "title", ascending: true)
        let query = CKQuery(recordType: "Item", predicate: predicate)
        query.sortDescriptors = [sort]

        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["title", "detail", "completed"]
        operation.resultsLimit = 50

        operation.recordFetchedBlock = recordFetched(record:)
        operation.queryCompletionBlock = queryCompletion(cursor:error:)

        CKContainer.default().publicCloudDatabase.add(operation)
    }

    func recordFetched(record: CKRecord) {
        let sharedItem = SharedItem(ckRecord: record)
        items.append(sharedItem)
        itemsLoadState = .success
    }

    func queryCompletion(cursor: CKQueryOperation.Cursor?, error: Error?) {
        if items.isEmpty {
            itemsLoadState = .noResults
        }
    }
}

struct SharedItemsView_Previews: PreviewProvider {
    static var previews: some View {
        SharedItemsView(project: SharedProject.example)
    }
}
