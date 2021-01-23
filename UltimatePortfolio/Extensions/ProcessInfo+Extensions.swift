//
//  ProcessInfo+Extensions.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 1/23/21.
//

import Foundation

public extension ProcessInfo {
    func isDebugNotTesting() -> Bool {
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCTestSessionIdentifier"] == nil {
            return true
        } else {
            return false
        }
        #else
        return false
        #endif
    }
}
