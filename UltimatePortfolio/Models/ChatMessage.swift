//
//  ChatMessage.swift
//  ChatMessage
//
//  Created by Marc Respass on 8/17/21.
//

import Foundation
import CloudKit

struct ChatMessage: Identifiable {
    let id: String
    let from: String
    let text: String
    let date: Date
}

extension ChatMessage {
    init(from record: CKRecord) {
        id = record.recordID.recordName
        from = record["from"] as? String ?? "No author"
        text = record["text"] as? String ?? "No text"
        date = record.creationDate ?? Date()
    }
}
