//
//  SharedProject.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 8/9/21.
//

import CloudKit
import Foundation

struct SharedProject: Identifiable {
    let id: String
    let title: String
    let detail: String
    let owner: String
    let closed: Bool

    static let example = SharedProject(id: "1", title: "Example", detail: "Detail", owner: "ILIOS", closed: false)

    init(id: String, title: String, detail: String, owner: String, closed: Bool) {
        self.id = id
        self.title = title
        self.detail = detail
        self.owner = owner
        self.closed = closed
    }

    init(ckRecord: CKRecord) {
        id = ckRecord.recordID.recordName
        title = ckRecord["title"] as? String ?? "No title"
        detail = ckRecord["detail"] as? String ?? ""
        owner = ckRecord["owner"] as? String ?? "No owner"
        closed = ckRecord["closed"] as? Bool ?? false
    }
}
