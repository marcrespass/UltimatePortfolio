//
//  SharedItem.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 8/9/21.
//

import Foundation

struct SharedItem: Identifiable {
    let id: String
    let title: String
    let detail: String
    let completed: Bool

    static let example = SharedItem(id: "1", title: "Example", detail: "Detail", completed: false)
}

/*
 UI might be in one of four states

 1. No data request has been made yet
 2. A data request is currently in flight
 3. Some successful data has been received
 4. The request finished without any results

 */
