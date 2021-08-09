//
//  SharedProject.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 8/9/21.
//

import Foundation

struct SharedProject: Identifiable {
    let id: String
    let title: String
    let detail: String
    let owner: String
    let closed: Bool

    static let example = SharedProject(id: "1", title: "Example", detail: "Detail", owner: "ILIOS", closed: false)
}
