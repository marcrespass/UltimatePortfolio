//
//  CloudError.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 9/27/21.
//

import CloudKit
import Foundation

struct CloudError: Identifiable, ExpressibleByStringInterpolation {
    var id: String { message }
    var message: String

    init(stringLiteral value: String) {
        self.message = value
    }
}
