//
//  DataController+AppLaunch.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 6/2/21.
//

import Foundation
import SwiftUI
import StoreKit

// MARK: - App launch behavior
extension DataController {
    func appLaunched() {
        guard count(for: Project.fetchRequest()) >= 5 else { return }

        let allScenes = UIApplication.shared.connectedScenes
        let scene = allScenes.first { $0.activationState == .foregroundActive }

        if let windowScene = scene as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
