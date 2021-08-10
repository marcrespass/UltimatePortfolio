//
//  SharedItem.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 8/9/21.
//

import CloudKit
import Foundation

struct SharedItem: Identifiable {
    let id: String
    let title: String
    let detail: String
    let completed: Bool

    static let example = SharedItem(id: "1", title: "Example", detail: "Detail", completed: false)

    init(ckRecord: CKRecord) {
        id = ckRecord.recordID.recordName
        title = ckRecord["title"] as? String ?? "No title"
        detail = ckRecord["detail"] as? String ?? ""
        completed = ckRecord["completed"] as? Bool ?? false
    }

    init(id: String, title: String, detail: String, completed: Bool) {
        self.id = id
        self.title = title
        self.detail = detail
        self.completed = completed
    }
}
