//
//  PlatformAdjustments.swift
//  UltimatePortfolioMac
//
//  Created by Marc Respass on 2/25/22.
//

// **** PlatformAdjustments iOS **** //
import SwiftUI

typealias ImageButtonStyle = BorderlessButtonStyle

extension Notification.Name {
    static let willResignActiveNotification = UIApplication.willResignActiveNotification
}

struct StackNavigationView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        NavigationView(content: content)
            .navigationViewStyle(.stack)
    }
}
