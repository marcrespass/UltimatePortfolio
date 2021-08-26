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

    @State private var messages = [ChatMessage]()

    @AppStorage("username") var username: String?
    @State private var showingSignIn = false
    @State private var newChatText = ""

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
        .sheet(isPresented: $showingSignIn, content: SignInView.init)
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

    func signIn() {
        showingSignIn = true
    }

    func sendChatMessage() {
        let text = newChatText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard text.count > 2,
        let username = username else { return }

        let message = CKRecord(recordType: "Message")
        message["from"] = username
        message["to"] = text

        let projectID = CKRecord.ID(recordName: project.id)
        message["project"] = CKRecord.Reference(recordID: projectID, action: .deleteSelf)

        let backupChatText = newChatText
        newChatText = ""

        CKContainer.default().publicCloudDatabase.save(message) { record, error in
            if let error = error {
                print(error.localizedDescription)
                newChatText = backupChatText
            } else if let record = record {
                let message = ChatMessage(from: record)
                messages.append(message)
            }
        }
    }
}

struct SharedItemsView_Previews: PreviewProvider {
    static var previews: some View {
        SharedItemsView(project: SharedProject.example)
    }
}
