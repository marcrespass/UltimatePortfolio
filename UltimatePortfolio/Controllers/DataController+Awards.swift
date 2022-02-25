//
//  DataController+Awards.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 6/2/21.
//

import Foundation
import CoreData

extension DataController {
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
            case "items":
                let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
                let awardCount = count(for: fetchRequest)
                return awardCount >= award.value
            case "complete":
                let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
                fetchRequest.predicate = NSPredicate(format: "completed = true")
                let awardCount = count(for: fetchRequest)
                return awardCount >= award.value
            case "chat":
                // return true if they posted a certain number of chat messages
                return UserDefaults.standard.integer(forKey: "chatCount") >= award.value
            default:
                // fatalError("Unknown award criterion \(award.criterion).")
                return false
        }
    }
}
