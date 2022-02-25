//
//  CloudError.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 9/27/21.
//

import SwiftUI
import CloudKit
import Foundation

struct CloudError: Identifiable, ExpressibleByStringInterpolation {
    var id: String { message }
    var message: String

    var localizedMessage: LocalizedStringKey {
        LocalizedStringKey(message)
    }

    init(stringLiteral value: String) {
        self.message = value
    }

    init(error: Error) {
        if let error = error as? CKError {
            switch error.code {
                case .badContainer, .badDatabase, .invalidArguments:
                    self.message = "A fatal error \(error.code) occurred: \(error.localizedDescription)"

                case .networkFailure, .networkUnavailable, .serverResponseLost, .serviceUnavailable:
                    self.message = "There was a problem communicating with iCloud; please check your network connection and try again."

                case .notAuthenticated:
                    self.message = "There was a problem with your iCloud account; please check that you're logged in to iCloud."

                case .requestRateLimited:
                    self.message = "You've hit iCloud's rate limit; please wait a moment then try again."

                case .quotaExceeded:
                    self.message = "You've exceeded your iCloud quota; please clear up some space then try again."

                default:
                    self.message = "An unknown error \(error.code) occurred: \(error.localizedDescription)"
            }
        } else {
            self.message = "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
